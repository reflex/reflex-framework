package reflex.core
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import reflex.behaviors.CompositeBehavior;
	
	public class Component extends MovieClip implements IBehavioral, ISkinnable
	{
		[Bindable] override public var enabled:Boolean;
		
		private var _behaviors:CompositeBehavior;
		
		public function Component()
		{
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
			if(_behaviors == null) {
				_behaviors = new CompositeBehavior(this);
			}
			return _behaviors;
		}
		
		public function set behaviors(value:*):void
		{
			if(_behaviors == null) {
				_behaviors = new CompositeBehavior(this);
			}
			_behaviors.clear();
			if (value is Array) {
				_behaviors.add(value);
			} else if (value is IBehavior) {
				_behaviors.add([value]);
			}
		}
		
		private var _skin:Object; [Bindable]
		public function get skin():Object { return _skin; }
		public function set skin(value:Object):void {
			if (_skin == value) {
				return;
			}
			if (_skin != null) {
				_skin.data = null;
			}
			
			_skin = value;
			
			if (_skin != null) {
				_skin.data = this;
			}
		}
		
	}
}