package reflex.components
{
	import flash.display.DisplayObject;
	
	import flight.events.PropertyEvent;
	import flight.observers.PropertyChange;
	
	import mx.utils.ObjectProxy;
	
	import reflex.behaviors.CompositeBehavior;
	import reflex.behaviors.IBehavior;
	import reflex.behaviors.IBehavioral;
	import reflex.display.Container;
	import reflex.display.ReflexDisplay;
	import reflex.events.InvalidationEvent;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	import reflex.skins.ISkin;
	import reflex.skins.ISkinnable;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	
	/**
	 * @alpha
	 */
	public class Component extends ReflexDisplay implements IBehavioral, ISkinnable
	{
		
		static public const MEASURE:String = "measure";
		InvalidationEvent.registerPhase(MEASURE, 0, true);
		
		private var _state:String;
		private var _skin:Object;
		private var _behaviors:CompositeBehavior;
		
		public function Component()
		{
			_behaviors = new CompositeBehavior(this);
			PropertyChange.addObserver(this, "skin", this, setTarget);
		}
		
		[Bindable] private var _style:ObjectProxy = new ObjectProxy();
		public function get style():Object { return _style; }
		public function set style(value:*):void {
			if(value is String) {
				var token:String = value as String;
				var assignments:Array = token.split(";");
				for each(var assignment:String in assignments) {
					var split:Array = assignment.split(":");
					var property:String = split[0];
					var v:String = split[1];
					_style[property] = v;
				}
			}
		}
		
		public function setStyle(property:String, value:*):void {
			style[property] = value;
		}
		
		[Bindable]
		public function get currentState():String
		{
			return _state;
		}
		public function set currentState(value:String):void
		{
			var change:PropertyChange = PropertyChange.begin();
			_state = change.add(this, "currentState", _state, value);
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
		public function get skin():Object
		{
			return _skin;
		}
		public function set skin(value:Object):void
		{
			var change:PropertyChange = PropertyChange.begin();
			_skin = change.add(this, "skin", _skin, value);
			//setSize(getWidth(_skin), getHeight(_skin));
			change.commit();
		}
		
		protected function setTarget(oldValue:*, newValue:*):void
		{
			if (oldValue != null) {
				oldValue.target = null;
			}
			
			if (newValue is ISkin) {
				newValue.target = this;
			} else if(newValue is DisplayObject) {
				addChild(newValue as DisplayObject);
			}
		}
		
	}
}
