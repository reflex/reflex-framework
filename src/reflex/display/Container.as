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
	
	import reflex.events.InvalidationEvent;
	import reflex.graphics.IDrawable;
	import reflex.layout.Block;
	import reflex.layout.Bounds;
	import reflex.layout.Box;
	//import reflex.layout.ILayoutAlgorithm;
	import reflex.layout.LayoutWrapper;
	import reflex.layouts.ILayout;
	
	[Event(name="init", type="flash.events.Event")]
	
	[DefaultProperty("children")]
	public class Container extends ReflexDisplay implements IContainer
	{
		
		static public const MEASURE:String = "measure";
		static public const LAYOUT:String = "layout";
		
		InvalidationEvent.registerPhase(MEASURE, 0, true);
		InvalidationEvent.registerPhase(LAYOUT, 0, true);
		
		private var _children:IList = new ArrayList();
		private var _layout:ILayout;
		
		public function Container()
		{
			initLayout();
			addEventListener(Event.ADDED, onInit);
			_children.addEventListener(ListEvent.LIST_CHANGE, onChildrenChange);
			addEventListener(MEASURE, onMeasure, false, 0, true);
			addEventListener(LAYOUT, onLayout, false, 0, true);
		}
		
		[ArrayElementType("Object")]
		public function get children():IList
		{
			return _children;
		}
		public function set children(value:*):void
		{
			if (value is DisplayObject) {
				_children.addItem(value);
			} else if (value is Array) {
				_children.removeItems();
				_children.addItems(value);
			} else if (value is IList) {
				_children.addItems( IList(value).getItems() );
			} else if (value is IDrawable) {
				_children.addItem(value);
			}
		}
		
		
		[Bindable(event="layoutChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			if(_layout) { _layout.target = null; }
			_layout = value;
			_layout.target = this;
			InvalidationEvent.invalidate(this, MEASURE);
			InvalidationEvent.invalidate(this, LAYOUT);
		}
		
		// remove these width/height overrides when layout invalidation binding works
		/*
		override public function set width(value:Number):void {
			super.width = value;
			InvalidationEvent.invalidate(this, LAYOUT);
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			InvalidationEvent.invalidate(this, LAYOUT);
		}
		*/
		public function invalidate(children:Boolean = false):void
		{
			// todo:invalidate layout
			//block.invalidate(children);
		}
		
		public function validate():void
		{
			// todo: validate layout
			//block.validate();
		}
		
		
		protected function draw():void
		{
			/*
			graphics.clear();
			graphics.beginFill(background);
			graphics.drawRect(0, 0, displayWidth, displayHeight);
			graphics.endFill();
			*/
		}
		
		protected function init():void
		{
		}
		
		protected function constructChildren():void
		{
		}
		
		protected function initLayout():void
		{
			/*
			block = new Block();
			block.addEventListener("xChange", forwardEvent);
			block.addEventListener("yChange", forwardEvent);
			block.addEventListener("displayWidthChange", forwardEvent);
			block.addEventListener("displayWidthChange", onWidthChange);
			block.addEventListener("displayHeightChange", forwardEvent);
			block.addEventListener("displayHeightChange", onHeightChange);
			block.addEventListener("snapToPixelChange", forwardEvent);
			block.addEventListener("layoutChange", forwardEvent);
			block.addEventListener("boundsChange", forwardEvent);
			block.addEventListener("marginChange", forwardEvent);
			block.addEventListener("paddingChange", forwardEvent);
			block.addEventListener("dockChange", forwardEvent);
			block.addEventListener("alignChange", forwardEvent);
			Bind.addBinding(block, "freeform", this, "freeform", true);
			block.target = this;
			*/
		}
		
		private function onRender(event:Event):void
		{
			draw();
		}
		
		private function onInit(event:Event):void
		{
			if (event.target != this) {
				return;
			}
			removeEventListener(Event.ADDED, onInit);
			
			constructChildren();
			init();
			if (hasEventListener(Event.INIT)) {
				dispatchEvent(new Event(Event.INIT));
			}
		}
		
		private function onChildrenChange(event:ListEvent):void
		{
			var child:DisplayObject;
			var loc:int = event.location1;
			switch (event.kind) {
				case ListEventKind.ADD :
					/*
					for each (child in event.items) {
						addChildAt(child, loc++);
					}*/
					reflex.display.addChildrenAt(this, event.items, loc);
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
					while (numChildren) {
						removeChildAt(numChildren-1);
					}
					/*
					for (var i:int = 0; i < _children.length; i++) {
						addChildAt(_children.getItemAt(i) as DisplayObject, i);
					}
					*/
					reflex.display.addChildrenAt(this, event.items, 0);
					break;
			}
			invalidate(true);
		}
		
		private function onMeasure(event:InvalidationEvent):void {
			if(isNaN(measurements.expliciteWidth) || isNaN(measurements.expliciteHeight)) {
				var items:Array = [];
				var length:int = _children.length;
				for(var i:int = 0; i < length; i++) {
					items.push(_children.getItemAt(i));
				}
				var point:Point = layout.measure(items);
				measurements.measuredWidth = point.x;
				measurements.measuredHeight = point.y;
				InvalidationEvent.invalidate(this, LAYOUT);
			}
		}
		
		private function onLayout(event:InvalidationEvent):void {
			var items:Array = [];
			var length:int = _children.length;
			for(var i:int = 0; i < length; i++) {
				items.push(_children.getItemAt(i));
			}
			var rectangle:Rectangle = new Rectangle(0, 0, width, height);
			layout.update(items, rectangle);
		}
		
		/*
		private function forwardEvent(event:Event):void
		{
			dispatchEvent(event);
		}
		
		private function onWidthChange(event:Event):void
		{
			dispatchEvent( new Event("widthChange") );
		}
		
		private function onHeightChange(event:Event):void
		{
			dispatchEvent( new Event("heightChange") );
		}
		*/
	}
}