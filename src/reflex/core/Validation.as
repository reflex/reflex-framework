package reflex.core
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * Utility class which centralizes logic for component validation. 
	 */
	public class Validation
	{
		/**
		 * Store the listeners temporarily so they may be removed. To remove
		 * an invalidated listener use uninvalidate.
		 */
		private static var listeners:Dictionary = new Dictionary();
		
		
		/**
		 * Invalidate a target display object. The <code>validateMethod</code>
		 * function will be called in the validation cycle. Priority may be used
		 * to cause certain types of functionality to happen sooner than others,
		 * such as measure before layout.
		 * 
		 * @param Any display object which is or will be on the stage.
		 * @param The validation method to be called during the validation cycle.
		 * @param Optional priority to cause some validation methods to be triggered before others.
		 */
		public static function invalidate(target:DisplayObject, validateMethod:Function, priority:int = 0):void
		{
			if (target.stage) {
				target.stage.invalidate();
			} else {
				target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			
			var listener:Function = function(event:Event):void {
				target.removeEventListener(Event.RENDER, listener);
				delete listeners[validateMethod];
				validateMethod();
			}
			
			listeners[validateMethod] = listener;
			
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
			if ( !(validateMethod in listeners) ) return;
			target.removeEventListener(Event.RENDER, listeners[validateMethod]);
			delete listeners[validateMethod];
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