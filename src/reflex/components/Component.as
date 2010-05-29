package reflex.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import flight.events.PropertyEvent;
	
	import reflex.behaviors.CompositeBehavior;
	import reflex.behaviors.IBehavior;
	import reflex.behaviors.IBehavioral;
	import reflex.display.Container;
	import reflex.display.ReflexDisplay;
	import reflex.display.addItem;
	import reflex.events.InvalidationEvent;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	import reflex.metadata.resolveCommitProperties;
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
		private var _style:Object;
		public function Component()
		{
			_style = new Object(); // need to make object props bindable - something like ObjectProxy but lighter?
			_behaviors = new CompositeBehavior(this);
			//PropertyChange.addObserver(this, "skin", this, setTarget);
			reflex.metadata.resolveCommitProperties(this);
		}
		
		[Bindable] 
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
		
		[Bindable(event="currentStateChange")]
		public function get currentState():String { return _state; }
		public function set currentState(value:String):void
		{
			_state = value;
			dispatchEvent(new Event("currentStateChange"));
			/*
			var change:PropertyChange = PropertyChange.begin();
			_state = change.add(this, "currentState", _state, value);
			change.commit();
			*/
		}
		
		
		[ArrayElementType("reflex.behaviors.IBehavior")]
		[Bindable(event="behaviorsChange")]
		[Inspectable(name="Behaviors", type=Array)]
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
			/*
			var change:PropertyChange = PropertyChange.begin();
			value = change.add(this, "behaviors", _behaviors, value);
			*/
			_behaviors.clear();
			if (value is Array) {
				_behaviors.add(value);
			} else if (value is IBehavior) {
				_behaviors.add([value]);
			}
			//change.commit();
			dispatchEvent(new Event("behaviorsChange"));
		}
		
		[Bindable(event="skinChange")]
		[Inspectable(name="Skin", type=Class)]
		public function get skin():Object
		{
			return _skin;
		}
		public function set skin(value:Object):void
		{
			_skin = value;
			if(_skin is ISkin) {
				(_skin as ISkin).target = this;
			} else if(_skin is DisplayObject) {
				reflex.display.addItem(this, _skin);
			}
			dispatchEvent(new Event("skinChange"));
		}
		
		[CommitProperties("width,height,skin")]
		public function updateSkinSize():void {
			
		}
		
	}
}
