package reflex.core
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import reflex.behaviors.BehaviorMap;

	public class Component extends MovieClip implements IBehavioral, ISkinnable
	{
		protected var _invalidated:Array = [];
		protected var _behaviorMap:BehaviorMap;
		
		
		public function Component()
		{
			_behaviorMap = new BehaviorMap(this);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		[ArrayElementType("reflex.core.IBehavior")]
		/**
		 * A dynamic object or hash map of behavior objects. <code>behaviors</code>
		 * is effectively read-only, but setting either an IBehavior or array of
		 * IBehavior to this property will add those behaviors to the <code>behaviors</code>
		 * object/map.
		 * 
		 * To set behaviors in MXML:
		 * <Component...>
		 *   <behaviors>
		 *     <SelectBehavior/>
		 *     <ButtonBehavior/>
		 *   </behaviors>
		 * </Component>
		 */
		public function get behaviors():Object
		{
			return _behaviorMap;
		}
		
		public function set behaviors(value:*):void
		{
			if (value is Array) {
				_behaviorMap.add(value);
			} else if (value is IBehavior) {
				_behaviorMap[IBehavior(value).name] = value;
			}
		}
		
		
		private var _skin:ISkin; [Bindable]
		public function get skin():ISkin { return _skin; }
		public function set skin(value:ISkin):void {
			removeSkin(_skin);
			_skin = value;
			addSkin(_skin);
		}
		
		private function removeSkin(skin:ISkin):void {
			if(skin) {
				if(skin is DisplayObject && this.contains(skin as DisplayObject)) {
					this.removeChild(skin as DisplayObject);
				}
				skin.data = null;
			}
		}
		
		private function addSkin(skin:ISkin):void {
			if(skin) {
				skin.data = this;
				if(skin is DisplayObject) {
					this.addChild(skin as DisplayObject);
				}
			}
		}
		
		
		/**
		 * Invalidate this component. The <code>validateMethod</code>
		 * function will be called in the validation cycle on stage render.
		 * Priority may be used to cause certain types of functionality to
		 * validate before than others, such as measure before layout.
		 * 
		 * @param The validation method to be called during the validation cycle.
		 * @param Optional priority to cause some validation methods to be
		 * triggered before others.
		 */
		public function invalidate(validationMethod:Function, priority:uint = 0, ...params):void
		{
			if (stage) {
				stage.invalidate();
			}
			
			// make sure the same method isn't added twice.
			if (isInvalidated(validationMethod)) {
				_invalidated.push({method: validationMethod, priority: priority, params: params});
				addEventListener(Event.RENDER, onRender);
			}
		}
		
		
		/**
		 * Whether or not this object has been invalidated and set to run its
		 * validation methods on the next render.
		 */
		public function get invalidated():Boolean
		{
			return _invalidated.length > 0;
		}
		
		
		/**
		 * Checks whether a method has already been invalidated.
		 * 
		 * @param The validation method which may have been invalidated.
		 * @return Whether that method was already invalidated.
		 */
		public function isInvalidated(validationMethod:Function):Boolean
		{
			var length:uint = _invalidated.length;
			for (var i:uint = 0; i < length; i++) {
				if (_invalidated[i].method == validationMethod) {
					return true;
				}
			}
			return false;
		}
		
		
		/**
		 * Removes a validation method from the invalidation queue. This method
		 * will no longer run on the next validation cycle.
		 * 
		 * @param The validation method that was invalidated.
		 * @return Whether the method was invalidated. Return false if the
		 * method was not previously invalidated.
		 */
		public function uninvalidate(validationMethod:Function):Boolean
		{
			var length:uint = _invalidated.length;
			for (var i:uint = 0; i < length; i++) {
				if (_invalidated[i].method == validationMethod) {
					_invalidated.splice(i, 0);
					if (!invalidated) {
						removeEventListener(Event.RENDER, onRender);
					}
					return true;
				}
			}
			return false;
		}
		
		
		/**
		 * Run the validation cycle for all invalidated methods.
		 * 
		 * @return Whether any validation methods were run.
		 */
		public function validate():Boolean
		{
			if (!invalidated) return false;
			removeEventListener(Event.RENDER, onRender);
			
			_invalidated.sortOn("priority", Array.NUMERIC);
			
			for each (var obj:Object in _invalidated) {
				obj.method.apply(null, obj.params);
			}
			
			_invalidated.length = 0;
			return true;
		}
		
		
		/**
		 * Triggers the validation cycle. Sorts validation methods by their
		 * priority and runs them.
		 */
		protected function onRender(event:Event):void
		{
			validate();
		}
		
		
		/**
		 * If this was invalidated while off the stage, it didn't get a chance
		 * to tell the stage to invalidate. Well, now it does! Go you, Mr.
		 * Component.
		 */
		protected function onAddedToStage(event:Event):void
		{
			if (invalidated) stage.invalidate();
		}
		
		
		
		// todo: Measurement
		
	}
}