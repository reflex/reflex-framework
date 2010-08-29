package reflex.display
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flight.binding.Bind;
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.events.PropertyEvent;
	import flight.list.ArrayList;
	import flight.list.IList;
	
	import reflex.components.IStateful;
	import reflex.events.InvalidationEvent;
	import reflex.graphics.IDrawable;
	import reflex.layouts.ILayout;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	import reflex.styles.IStyleable;
	
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	
	[Event(name="initialize", type="reflex.events.InvalidationEvent")]
	
	[DefaultProperty("content")]
	
	/**
	 * Used to contain and layout children.
	 * 
	 * @alpha
	 */
	public class Container extends StyleableSprite implements IContainer, IStateful
	{
		
		static public const CREATE:String = "create";
		static public const INITIALIZE:String = "initialize";
		static public const MEASURE:String = "measure";
		static public const LAYOUT:String = "layout";
		
		InvalidationEvent.registerPhase(CREATE, 0, true);
		InvalidationEvent.registerPhase(INITIALIZE, 1, true);
		InvalidationEvent.registerPhase(MEASURE, 2, true);
		InvalidationEvent.registerPhase(LAYOUT, 3, false);
		
		private var _layout:ILayout;
		private var _template:Object;
		private var _content:IList;
		private var renderers:Array;
		
		private var _states:Array;
		private var _currentState:String;
		
		
		public function Container()
		{
			if(_template == null) {
				//_template = new ReflexDataTemplate();
			}
			if(_layout == null) {
				//_layout = new XYLayout();
			}
			
			addEventListener(Event.ADDED, onAdded, false, 0, true);
			addEventListener(MEASURE, onMeasure, false, 0, true);
			addEventListener(LAYOUT, onLayout, false, 0, true);
			//addEventListener("widthChange", onSizeChange, false, 0, true);
			//addEventListener("heightChange", onSizeChange, false, 0, true);
		}
		
		// width/height invalidation needs some thought
		
		private function onSizeChange(event:Event):void {
			InvalidationEvent.invalidate(this, LAYOUT);
		}
		
		// IStateful implementation
		
		[Bindable(event="statesChange")]
		public function get states():Array { return _states; }
		public function set states(value:Array):void {
			if(_states == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "states", _states, _states = value);
		}
		
		
		[Bindable(event="currentStateChange")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			if(_currentState == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "currentState", _currentState, _currentState = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("Object")]
		[Bindable(event="contentChange")]
		public function get content():IList { return _content; }
		public function set content(value:*):void
		{
			if(_content == value) {
				return;
			}
			
			var oldContent:IList = _content;
			
			if(_content) {
				_content.removeEventListener(ListEvent.LIST_CHANGE, onChildrenChange);
			}
			
			if(value == null) {
				_content = null;
			} else if(value is IList) {
				_content = value as IList;
			} else if(value is Array || value is Vector) {
				_content = new ArrayList(value);
			} else {
				_content = new ArrayList([value]);
			}
			
			if(_content) {
				_content.addEventListener(ListEvent.LIST_CHANGE, onChildrenChange);
				var items:Array = [];
				for (var i:int = 0; i < _content.length; i++) {
					items.push(_content.getItemAt(i));
				}
				reset(items);
			}
			InvalidationEvent.invalidate(this, MEASURE);
			InvalidationEvent.invalidate(this, LAYOUT);
			PropertyEvent.dispatchChange(this, "content", oldContent, _content);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="layoutChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			if(_layout == value) {
				return;
			}
			var oldLayout:ILayout = _layout;
			if(_layout) { _layout.target = null; }
			_layout = value;
			if(_layout) { _layout.target = this; }
			InvalidationEvent.invalidate(this, MEASURE);
			InvalidationEvent.invalidate(this, LAYOUT);
			PropertyEvent.dispatchChange(this, "layout", oldLayout, _layout);
		}
		
		[Bindable(event="templateChange")]
		public function get template():Object { return _template; }
		public function set template(value:Object):void {
			if(_template == value) {
				return;
			}
			var oldTemplate:Object = _template;
			_template = value;
			if(_content != null) {
				var items:Array = [];
				var length:int = _content.length;
				for(var i:int = 0; i < length; i++) {
					var child:Object = _content.getItemAt(i);
					items.push(child);
				}
				reset(items);
			}
			InvalidationEvent.invalidate(this, MEASURE);
			InvalidationEvent.invalidate(this, LAYOUT);
			PropertyEvent.dispatchChange(this, "template", oldTemplate, _template);
		}
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED, onAdded, false);
			InvalidationEvent.invalidate(this, CREATE);
			InvalidationEvent.invalidate(this, INITIALIZE);
		}
		
		private function onMeasure(event:InvalidationEvent):void {
			if((isNaN(explicite.width) || isNaN(explicite.height)) && layout) {
				var point:Point = layout.measure(renderers);
				measured.width = point.x;
				measured.height = point.y;
			}
		}
		
		private function onLayout(event:InvalidationEvent):void {
			if(layout) {
				//var width:Number = reflex.measurement.resolveWidth(this);
				//var height:Number = reflex.measurement.resolveHeight(this);
				var rectangle:Rectangle = new Rectangle(0, 0, unscaledWidth, unscaledHeight);
				layout.update(renderers, rectangle);
			}
		}
		
		private function onChildrenChange(event:ListEvent):void
		{
			var child:DisplayObject;
			var loc:int = event.location1;
			switch (event.kind) {
				case ListEventKind.ADD :
					add(event.items, loc);
					break;
				case ListEventKind.REMOVE :
					for each (child in event.items) {
						removeChild(child);
					}
					break;
				case ListEventKind.REPLACE :
					removeChild(event.items[1]);
					//addChildAt(event.items[0], loc);
					break;
				case ListEventKind.RESET :
				default:
					reset(event.items);
					break;
			}
			InvalidationEvent.invalidate(this, LAYOUT);
		}
		
		private function add(items:Array, index:int):void {
			var children:Array = reflex.display.addItemsAt(this, items, index, _template);
			renderers.concat(children); // todo: correct ordering
		}
		
		private function reset(items:Array):void {
			while (numChildren) {
				removeChildAt(numChildren-1);
			}
			renderers = reflex.display.addItemsAt(this, items, 0, _template); // todo: correct ordering
			InvalidationEvent.invalidate(this, LAYOUT);
		}
		
		
	}
}