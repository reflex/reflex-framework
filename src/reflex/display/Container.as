package reflex.display
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import reflex.collections.SimpleCollection;
	import reflex.components.IStateful;
	import reflex.events.PropertyEvent;
	import reflex.events.RenderPhase;
	import reflex.layouts.ILayout;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	
	[Event(name="initialize", type="reflex.events.RenderPhase")]
	
	[DefaultProperty("content")]
	
	/**
	 * Used to contain and layout children.
	 * 
	 * @alpha
	 */
	public class Container extends Display implements IContainer, IStateful
	{
		
		static public const CREATE:String = "create";
		static public const INITIALIZE:String = "initialize";
		static public const MEASURE:String = "measure";
		static public const LAYOUT:String = "layout";
		
		RenderPhase.registerPhase(CREATE, 0, true);
		RenderPhase.registerPhase(INITIALIZE, 1, true);
		RenderPhase.registerPhase(MEASURE, 2, true);
		RenderPhase.registerPhase(LAYOUT, 3, false);
		
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
			RenderPhase.invalidate(this, LAYOUT);
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
				_content.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChange);
			}
			
			if(value == null) {
				_content = null;
			} else if(value is IList) {
				_content = value as IList;
			} else if(value is Array || value is Vector) {
				_content = new SimpleCollection(value);
			} else {
				_content = new SimpleCollection([value]);
			}
			
			if(_content) {
				_content.addEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChange);
				var items:Array = [];
				for (var i:int = 0; i < _content.length; i++) {
					items.push(_content.getItemAt(i));
				}
				reset(items);
			}
			RenderPhase.invalidate(this, MEASURE);
			RenderPhase.invalidate(this, LAYOUT);
			dispatchEvent( new Event("childrenChange") );
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
			RenderPhase.invalidate(this, MEASURE);
			RenderPhase.invalidate(this, LAYOUT);
			dispatchEvent( new Event("layoutChange") );
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
			RenderPhase.invalidate(this, MEASURE);
			RenderPhase.invalidate(this, LAYOUT);
			dispatchEvent( new Event("templateChange") );
		}
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED, onAdded, false);
			RenderPhase.invalidate(this, CREATE);
			RenderPhase.invalidate(this, INITIALIZE);
		}
		
		private function onMeasure(event:Event):void {
			if((isNaN(explicite.width) || isNaN(explicite.height)) && layout) {
				var point:Point = layout.measure(renderers);
				measured.width = point.x;
				measured.height = point.y;
			}
		}
		
		private function onLayout(event:Event):void {
			if(layout) {
				//var width:Number = reflex.measurement.resolveWidth(this);
				//var height:Number = reflex.measurement.resolveHeight(this);
				var rectangle:Rectangle = new Rectangle(0, 0, unscaledWidth, unscaledHeight);
				layout.update(renderers, rectangle);
			}
		}
		
		private function onChildrenChange(event:CollectionEvent):void
		{
			var child:DisplayObject;
			var loc:int = event.location;
			switch (event.kind) {
				//case ListEventKind.ADD :
				case CollectionEventKind.ADD :
					add(event.items, loc);
					break;
				case CollectionEventKind.REMOVE :
					for each (child in event.items) {
						removeChild(child);
					}
					break;
				case CollectionEventKind.REPLACE :
					removeChild(event.items[1]);
					//addChildAt(event.items[0], loc);
					break;
				case CollectionEventKind.RESET :
				default:
					reset(event.items);
					break;
			}
			RenderPhase.invalidate(this, LAYOUT);
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
			RenderPhase.invalidate(this, LAYOUT);
		}
		
		
	}
}