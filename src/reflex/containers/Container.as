package reflex.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.IList;
	import mx.core.mx_internal;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.states.IOverride;
	import mx.states.State;
	
	import reflex.binding.DataChange;
	import reflex.collections.SimpleCollection;
	import reflex.components.IStateful;
	import reflex.display.Display;
	import reflex.invalidation.Invalidation;
	import reflex.layouts.BasicLayout;
	import reflex.layouts.ILayout;
	import reflex.states.applyState;
	import reflex.states.removeState;
	import reflex.templating.addItemsAt;
	import reflex.collections.convertToIList;
	
	//use namespace mx_internal;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	//[Style(name="align")]
	
	[Event(name="initialize", type="flash.events.Event")]
	[Event(name="create", type="flash.events.Event")]
	
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
		
		Invalidation.registerPhase(CREATE, 0, true);
		Invalidation.registerPhase(INITIALIZE, 100, true);
		Invalidation.registerPhase(MEASURE, 200, false);
		Invalidation.registerPhase(LAYOUT, 300, true);
		
		private var _layout:ILayout;
		private var _template:Object;
		private var _content:IList;
		private var renderers:Array;
		
		private var _states:Array;
		private var _transitions:Array;
		private var _currentState:String;
		private var _styleDeclaration:* = {};
		private var _styleManager:* = {};
		
		public function Container()
		{
			if (_template == null) {
				//_template = new ReflexDataTemplate();
			}
			if (_layout == null) {
				//_layout = new BasicLayout();
			}
			content = new SimpleCollection(); // use setter logic
			//_content.addEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChange);
			addEventListener(Event.ADDED, onAdded, false, 0, true);
			addEventListener(MEASURE, onMeasure, false, 0, true);
			addEventListener(LAYOUT, onLayout, false, 0, true);
			//addEventListener("widthChange", onSizeChange, false, 0, true);
			//addEventListener("heightChange", onSizeChange, false, 0, true);
		}
		
		// width/height invalidation needs some thought
		
		private function onSizeChange(event:Event):void {
			Invalidation.invalidate(this, LAYOUT);
		}
		
		// IStateful implementation
		
		[Bindable(event="statesChange")]
		public function get states():Array { return _states; }
		public function set states(value:Array):void {
			DataChange.change(this, "states", _states, _states = value);
		}
		
		[Bindable(event="transitionsChange")]
		public function get transitions():Array { return _transitions; }
		public function set transitions(value:Array):void {
			DataChange.change(this, "transitions", _transitions, _transitions = value);
		}
		
		[Bindable(event="currentStateChange")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void {
			if (_currentState == value) {
				return;
			}
			// might need to add invalidation for this later
			reflex.states.removeState(this, _currentState, states);
			DataChange.change(this, "currentState", _currentState, _currentState = value);
			reflex.states.applyState(this, _currentState, states);
		}
		
		public function hasState(state:String):Boolean {
			for each(var s:Object in states) {
				if(s.name == state) {
					return true;
				}
			}
			return false;
		}
		
		// the compiler goes looking for styleDeclaration and styleManager properties when setting styles on root elements
		// ... but they don't really have to be anything specific :)
		
		public function get styleDeclaration():* { return _styleDeclaration; }
		public function set styleDeclaration(value:*):void {
			_styleDeclaration = value;
		}
		
		public function get styleManager():* { return _styleManager; }
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("Object")]
		[Bindable(event="contentChange")]
		public function get content():IList { return _content; }
		public function set content(value:*):void
		{
			if (_content == value) {
				return;
			}
			
			var oldContent:IList = _content;
			
			if (_content) {
				_content.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChange);
			}
			
			_content = reflex.collections.convertToIList(value);
			
			if (_content) {
				_content.addEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChange);
				var items:Array = [];
				for (var i:int = 0; i < _content.length; i++) {
					items.push(_content.getItemAt(i));
				}
			}
			reset(items);
			Invalidation.invalidate(this, MEASURE);
			Invalidation.invalidate(this, LAYOUT);
			//dispatchEvent( new Event("contentChange") );
			DataChange.change(this, "content", oldContent, _content);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="layoutChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			if (_layout == value) {
				return;
			}
			var oldLayout:ILayout = _layout;
			if (_layout) { _layout.target = null; }
			_layout = value;
			if (_layout) { _layout.target = this; }
			Invalidation.invalidate(this, MEASURE);
			Invalidation.invalidate(this, LAYOUT);
			//dispatchEvent( new Event("layoutChange") );
			DataChange.change(this, "layout", oldLayout, _layout);
		}
		
		[Bindable(event="templateChange")]
		public function get template():Object { return _template; }
		public function set template(value:Object):void {
			if (_template == value) {
				return;
			}
			var oldTemplate:Object = _template;
			_template = value;
			if (_content != null) {
				var items:Array = [];
				var length:int = _content.length;
				for (var i:int = 0; i < length; i++) {
					var child:Object = _content.getItemAt(i);
					items.push(child);
				}
				reset(items);
			}
			Invalidation.invalidate(this, MEASURE);
			Invalidation.invalidate(this, LAYOUT);
			//dispatchEvent( new Event("templateChange") );
			DataChange.change(this, "template", oldTemplate, _template);
		}
		
		override public function setSize(width:Number, height:Number):void {
			super.setSize(width, height);
			Invalidation.invalidate(this, LAYOUT);
		}
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED, onAdded, false);
			Invalidation.invalidate(this, CREATE);
			Invalidation.invalidate(this, INITIALIZE);
		}
		
		protected function onMeasure(event:Event):void {
			// the compiler gives us root styles like this. yay?
			if(styleDeclaration.defaultFactory != null) {
				var f:Function = styleDeclaration.defaultFactory;
				var t:* = f.apply(style);
				styleDeclaration.defaultFactory = null
			}
			if ((isNaN(explicit.width) || isNaN(explicit.height)) 
				//|| (isNaN(percentWidth) || isNaN(percentHeight))
				&& layout) {
				var point:Point = layout.measure(renderers);
				if (point.x != measured.width || point.y != measured.height) {
					measured.width = point.x;
					measured.height = point.y;
				}
			}
		}
		
		private function onLayout(event:Event):void {
			if (layout) {
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
					remove(event.items, loc);
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
			Invalidation.invalidate(this, LAYOUT);
		}
		
		private function add(items:Array, index:int):void {
			var children:Array = reflex.templating.addItemsAt(this, items, index, _template);
			
			var length:int = items.length;
			for(var i:int = 0; i < length; i++) {
				renderers.splice(index+i, 0, items[i]);
			}
			
			Invalidation.invalidate(this, MEASURE);
			Invalidation.invalidate(this, LAYOUT);
		}
		
		private function remove(items:Array, index:int):void {
			// this isn't working with templating yet
			var child:Object;
			for each (child in items) {
				removeChild(child as DisplayObject);
				var index:int = renderers.indexOf(child);
				renderers.splice(index, 1);
			}
			Invalidation.invalidate(this, MEASURE);
			Invalidation.invalidate(this, LAYOUT);
		}
		
		private function reset(items:Array):void {
			while (numChildren) {
				removeChildAt(numChildren-1);
			}
			renderers = reflex.templating.addItemsAt(this, items, 0, _template); // todo: correct ordering
			Invalidation.invalidate(this, LAYOUT);
		}
		
		
	}
}