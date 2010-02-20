package reflex.display
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import flight.binding.Bind;
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.list.ArrayList;
	import flight.list.IList;
	
	import reflex.layout.Block;
	import reflex.layout.Bounds;
	import reflex.layout.Box;
	import reflex.layout.ILayoutAlgorithm;
	
	[DefaultProperty("children")]
	public class Container extends MovieClip
	{
		[Bindable]
		public var freeform:Boolean = false;
		
		public var block:Block;
		
		private var _children:IList = new ArrayList();
		
		// TODO: add propertyChange updates (via Block as well)
		public function Container()
		{
			addEventListener(Event.ADDED, onInit);
			_children.addEventListener(ListEvent.LIST_CHANGE, onChildrenChange);
			initLayout();
		}
		
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
			}
		}
		
		[Bindable(event="xChange")]
		override public function get x():Number
		{
			return super.x;
		}
		override public function set x(value:Number):void
		{
			if (super.x == value) {
				return;
			}
			
			super.x = value;
			block.x = value;
		}
		
		[Bindable(event="yChange")]
		override public function get y():Number
		{
			return block.y;
		}
		override public function set y(value:Number):void
		{
			if (super.y == value) {
				return;
			}
			
			super.y = value;
			block.y = value;
		}
		
		[Bindable(event="widthChange")]
		override public function get width():Number
		{
			return displayWidth * scaleX;
		}
		override public function set width(value:Number):void
		{
			displayWidth = value / scaleY;
		}
		
		[Bindable(event="heightChange")]
		override public function get height():Number
		{
			return displayHeight * scaleY;
		}
		override public function set height(value:Number):void
		{
			displayHeight = value / scaleY;
		}
		
		
		[Bindable(event="displayWidthChange")]
		public function get displayWidth():Number
		{
			return block.displayWidth;
		}
		public function set displayWidth(value:Number):void
		{
			block.displayWidth = value;
		}
		
		[Bindable(event="displayHeightChange")]
		public function get displayHeight():Number
		{
			return block.displayHeight;
		}
		public function set displayHeight(value:Number):void
		{
			block.displayHeight = value;
		}
		
		[Bindable(event="snapToPixelChange")]
		public function get snapToPixel():Boolean
		{
			return block.snapToPixel;
		}
		public function set snapToPixel(value:Boolean):void
		{
			block.snapToPixel = value;
		}
		
		
		[Bindable(event="layoutChange")]
		public function get layout():ILayoutAlgorithm
		{
			return block.algorithm;
		}
		public function set layout(value:ILayoutAlgorithm):void
		{
			block.algorithm = value;
		}
		
		[Bindable(event="boundsChange")]
		public function get bounds():Bounds
		{
			return block.bounds;
		}
		public function set bounds(value:Bounds):void
		{
			block.bounds = value;
		}
		
		[Bindable(event="marginChange")]
		public function get margin():Box
		{
			return block.margin;
		}
		public function set margin(value:*):void
		{
			block.margin = value;
		}
		
		[Bindable(event="paddingChange")]
		public function get padding():Box
		{
			return block.padding;
		}
		public function set padding(value:*):void
		{
			block.padding = value;
		}
		
		[Bindable(event="anchorChange")]
		public function get anchor():Box
		{
			return block.anchor;
		}
		public function set anchor(value:*):void
		{
			block.anchor = value;
		}
		
		[Bindable(event="dockChange")]
		public function get dock():String
		{
			return block.dock;
		}
		public function set dock(value:String):void
		{
			block.dock = value;
		}
		
		[Bindable(event="alignChange")]
		public function get align():String
		{
			return block.align;
		}
		public function set align(value:String):void
		{
			block.align = value;
		}
		
		
		
		public function invalidate(children:Boolean = false):void
		{
			block.invalidate(children);
		}
		
		public function validate():void
		{
			block.validate();
		}
		
		
		protected function init():void
		{
		}
		
		protected function initLayout():void
		{
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
		}
		
		protected function onChildrenChange(event:ListEvent):void
		{
			var child:DisplayObject;
			var loc:int = event.location1;
			switch (event.kind) {
				case ListEventKind.ADD :
					for each (child in event.items) {
						addChildAt(child, loc++);
					}
					break;
				case ListEventKind.REMOVE :
					for each (child in event.items) {
						removeChild(child);
					}
					break;
				case ListEventKind.REPLACE :
					removeChild(event.items[1]);
					addChildAt(event.items[0], loc);
					break;
				case ListEventKind.RESET :
					while (numChildren) {
						removeChildAt(numChildren-1);
					}
					for (var i:int = 0; i < _children.length; i++) {
						addChildAt(_children.getItemAt(i) as DisplayObject, i);
					}
					break;
			}
		}
		
		private function onInit(event:Event):void
		{
			block.target = this;
			init();
		}
		
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
	}
}