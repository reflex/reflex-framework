package reflex.components
{
	import flight.events.PropertyEvent;
	import flight.observers.Observe;
	
	import reflex.behaviors.CompositeBehavior;
	import reflex.behaviors.IBehavior;
	import reflex.behaviors.IBehavioral;
	import reflex.display.Container;
	import reflex.layout.ILayoutAlgorithm;
	import reflex.skins.ISkin;
	import reflex.skins.ISkinnable;
	
	public class Component extends Container implements IBehavioral, ISkinnable
	{
		private var _state:String;
		private var _data:Object;
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
		
		
		[Bindable]
		public function get state():String
		{
			return _state;
		}
		public function set state(value:String):void
		{
			_state = Observe.change(this, "state", _state, value);
			Observe.notify();
		}
		
		
		[Bindable]
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = Observe.change(this, "data", _data, value);
			Observe.notify();
		}
		
		
		[ArrayElementType("reflex.behaviors.IBehavior")]
		/**
		 * A dynamic object or hash map of behavior objects. <code>behaviors</code>
		 * is effectively read-only, but setting either an IBehavior or array of
		 * IBehavior to this property will add those behaviors to the <code>behaviors</code>
		 * object/map.
		 * 
		 * To set behaviors in MXML:
		 * &lt;Component...&gt;
		 *   &lt;behaviors&gt;
		 *     &lt;SelectBehavior/&gt;
		 *     &lt;ButtonBehavior/&gt;
		 *   &lt;/behaviors&gt;
		 * &lt;/Component&gt;
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
			
			var oldValue:ISkin = _skin;
			_skin = Observe.change(this, "skin", _skin, value);
			
			if (oldValue != _skin && _skin != null) {
				_skin.target = this;
			}
			Observe.notify();
		}
		
		override protected function constructChildren():void
		{
			// load skin from CSS, etc
		}
		
	}
}
