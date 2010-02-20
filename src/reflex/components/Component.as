package reflex.components
{
	import reflex.behaviors.CompositeBehavior;
	import reflex.behaviors.IBehavior;
	import reflex.behaviors.IBehavioral;
	import reflex.display.Container;
	import reflex.layout.ILayoutAlgorithm;
	import reflex.skins.ISkin;
	import reflex.skins.ISkinnable;
	
	public class Component extends Container implements IBehavioral, ISkinnable
	{
		[Bindable]
		public var state:String;
		
		[Bindable]
		public var data:Object;
		
		private var _skin:ISkin; 
		private var _behaviors:CompositeBehavior;
		private var _layout:ILayoutAlgorithm;
		
		public function Component()
		{
		}
		
		override public function get layout():ILayoutAlgorithm
		{
			return _skin.layout;
		}
		override public function set layout(value:ILayoutAlgorithm):void
		{
			_skin.layout = value;
		}
		
		
		[ArrayElementType("reflex.behaviors.IBehavior")]
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
		
		[Bindable]
		public function get skin():ISkin
		{
			return _skin;
		}
		public function set skin(value:ISkin):void
		{
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