package reflex.core
{
	import flash.display.MovieClip;
	
	import flight.list.IList;
	
	import reflex.behavior.CompositeBehavior;
	import reflex.layout.ILayoutAlgorithm;
	
	public class Component extends MovieClip implements IBehavioral, ISkinnable
	{
		//[Bindable] override public var enabled:Boolean;
		
		private var _behaviors:CompositeBehavior;
		
		public function Component()
		{
		}
		
		[Bindable]
		public var layout:ILayoutAlgorithm;
		
		[Bindable]
		public var state:String;
		
		[Bindable]
		public var data:Object;
		
		[Bindable]
		public var children:IList;
		
		
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
		public function get behaviors():CompositeBehavior
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
		
		private var _skin:ISkin; [Bindable]
		public function get skin():ISkin { return _skin; }
		public function set skin(value:ISkin):void {
			if (_skin == value) {
				return;
			}
			if (_skin != null) {
				_skin.target = null;
			}
			
			_skin = value;
			
			if (_skin != null) {
				_skin.target = this;
			}
		}
		
	}
}