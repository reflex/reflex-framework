package reflex.components
{
	import flight.events.PropertyEvent;
	import flight.observers.PropertyChange;
	
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
			_behaviors = new CompositeBehavior(this);
			PropertyChange.addObserver(this, "skin", this, setTarget);
		}
		
		override public function get layout():ILayoutAlgorithm
		{
			return _skin.layout;
		}
		override public function set layout(value:ILayoutAlgorithm):void
		{
			var change:PropertyChange = PropertyChange.begin();
			_skin.layout = change.add(this, "layout", _skin.layout, value);
			change.commit();
		}
		
		
		[Bindable]
		public function get state():String
		{
			return _state;
		}
		public function set state(value:String):void
		{
			var change:PropertyChange = PropertyChange.begin();
			_state = change.add(this, "state", _state, value);
			change.commit();
		}
		
		
		[Bindable]
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			var change:PropertyChange = PropertyChange.begin();
			_data = change.add(this, "data", _data, value);
			change.commit();
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
			return _behaviors;
		}
		public function set behaviors(value:*):void
		{
			var change:PropertyChange = PropertyChange.begin();
			value = change.add(this, "behaviors", _behaviors, value);
			_behaviors.clear();
			if (value is Array) {
				_behaviors.add(value);
			} else if (value is IBehavior) {
				_behaviors.add([value]);
			}
			change.commit();
		}
		
		[Bindable]
		public function get skin():ISkin
		{
			return _skin;
		}
		public function set skin(value:ISkin):void
		{
			var change:PropertyChange = PropertyChange.begin();
			_skin = change.add(this, "skin", _skin, value);
			change.commit();
		}
		
		protected function setTarget(oldValue:*, newValue:*):void
		{
			if (oldValue != null) {
				oldValue.target = null;
			}
			
			if (newValue != null) {
				newValue.target = this;
			}
		}
		
		override protected function constructChildren():void
		{
			if (skin == null) {	// else skin was set in mxml
				// load skin from CSS, etc
			}
		}
		
	}
}
