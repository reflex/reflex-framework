package reflex.core
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * Utility class which centralizes logic for component validation. Rather
	 * than having many invalidation/validation method pairs a validation method
	 * is passed in to the <code>invalidate</code> method. This allows add-on
	 * code such as layouts and animation libraries to tie into the validation
	 * of a component, and it makes for cleaner code.
	 * 
	 * Example on a mythical <code>Layout</code> object:
	 * 
	 * public function set percentWidth(value:Number):void
	 * {
	 *     if (value == _percentWidth) return;
	 *     _percentWidth = value;
	 *     Validation.invalidate(target, validate);
	 * }
	 */
	public class Invalidator
	{
		/**
		 * Store the listeners associated with a validateMethod temporarily so
		 * they may be removed. To remove an invalidated listener use
		 * uninvalidate.
		 */
		protected static var validateMethods:Dictionary = new Dictionary(true);
		
		/**
		 * Store the listeners associated with eventTargets and an event name.
		 * To remove a registered event use unregister.
		 */
		protected static var eventTargets:Dictionary = new Dictionary(true);
		
		
		/**
		 * Register events to trigger an invalidate. Every time this event is
		 * dispatched invalidate will be called with the provided <code>displayTarget</code>,
		 * <code>validateMethod</code>, and <code>priority</code>.
		 * 
		 * @param The target which will be dispatching the events. This may be the
		 * same as the display target, but could often be different.
		 * @param An array of one or more event types which will trigger the
		 * invalidation.
		 * @param Any display object which is or will be on the stage which this
		 * invalidation affects.
		 * @param The validation method to be called during the validation cycle.
		 * @param Optional priority to cause some validation methods to be triggered before others.
		 */
		public static function register(eventTarget:IEventDispatcher, events:Array, displayTarget:DisplayObject, validateMethod:Function, priority:int = 0):void
		{
			for each (var type:String in events) {
				var listener:Function = function(event:Event):void {
					invalidate(displayTarget, validateMethod, priority);
				};
				
				var listeners:Object = eventTargets[eventTarget];
				if (listeners == null) {
					eventTargets[eventTarget] = listeners = {};
				}
				listeners[type] = listener;
				
				eventTarget.addEventListener(type, listener);
			}
		}
		
		
		/**
		 * Unregister events which were previously registered with <code>register</code>.
		 * 
		 * @param The target which was dispatching the events.
		 * @param An array of one or more event types which trigged the
		 * invalidation.
		 */
		public static function unregister(eventTarget:IEventDispatcher, events:Array):void
		{
			for each (var type:String in events) {
				var listeners:Object = eventTargets[eventTarget];
				if (listeners == null) return;
				
				var listener:Function = listeners[type];
				if (listener == null) return;
				
				delete listeners[type];
				
				eventTarget.removeEventListener(type, listener);
			}
		}
		
		
		/**
		 * Invalidate a target display object. The <code>validateMethod</code>
		 * function will be called in the validation cycle. Priority may be used
		 * to cause certain types of functionality to happen sooner than others,
		 * such as measure before layout.
		 * 
		 * @param Any display object which is or will be on the stage which this
		 * invalidation affects.
		 * @param The validation method to be called during the validation cycle.
		 * @param Optional priority to cause some validation methods to be triggered before others.
		 */
		public static function invalidate(target:DisplayObject, validateMethod:Function, priority:int = 0):void
		{
			if (validateMethod in validateMethods) return;
			
			if (target.stage) {
				target.stage.invalidate();
			} else {
				target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			
			var listener:Function = function(event:Event):void {
				target.removeEventListener(Event.RENDER, listener);
				delete validateMethods[validateMethod];
				validateMethod();
			}
			
			// add the validateMethod to a dummy event listener on the displayTarget.
			// if it is not reference directly like this, it will slip out of our
			// weak-reference dictionary. But the only thing that targets it is the
			// target, so when that goes, so does the validateMethod. All clean.
			// This event should never be dispatched
			target.addEventListener("_$hold$_", validateMethod);
			
			validateMethods[validateMethod] = listener;
			
			target.addEventListener(Event.RENDER, listener, false, priority);
		}
		
		
		/**
		 * Remove a validation method from the validation cycle. This should be
		 * used when the validation no longer needs to happen, such as when the
		 * target of a skin is changed etc.
		 * 
		 * This may be called safely when it is uncertain whether invalidate
		 * was called previously.
		 * 
		 * @param The display object which may have been previously invalidated.
		 * @param The validation method added in <code>invalidate</code>.
		 */
		public static function uninvalidate(target:DisplayObject, validateMethod:Function):void
		{
			if ( !(validateMethod in validateMethods) ) return;
			target.removeEventListener(Event.RENDER, validateMethods[validateMethod]);
			delete validateMethods[validateMethod];
		}
		
		
		/**
		 * Run the validation cycle for the the provided validation method. If
		 * no validation method is provided, run the validation cycle for the
		 * whole target.
		 * 
		 * @param The display object which may have been previously invalidated.
		 * @param The validation method added in <code>invalidate</code>. If
		 * not provided will validate all invalidated methods.
		 */
		public static function validate(target:DisplayObject, validateMethod:Function = null):void
		{
			if (validateMethod != null) {
				uninvalidate(target, validateMethod);
				validateMethod();
			} else {
				target.dispatchEvent(new Event(Event.RENDER));
			}
		}
		
		
		/**
		 * Invalidates the stage for targets which were invalidated before being
		 * added to the stage. This keeps processing down for targets which are
		 * off-stage and don't need validation.
		 */
		private static function onAddedToStage(event:Event):void
		{
			DisplayObject(event.target).removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			DisplayObject(event.target).stage.invalidate();
		}
	}
}