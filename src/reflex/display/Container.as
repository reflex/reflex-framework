package reflex.display
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.events.PropertyEvent;
	import flight.list.ArrayList;
	import flight.list.IList;
	
	import reflex.layout.Block;
	import reflex.layout.Bounds;
	import reflex.layout.Box;
	import reflex.layout.ILayoutAlgorithm;
	import reflex.layout.Layout;
	
	[DefaultProperty("children")]
	public class Container extends MovieClip
	{
		protected var block:Block;
		
		private var _children:IList = new ArrayList();
		
		// TODO: add propertyChange updates (via Block as well)
		public function Container()
		{
			block = new Block();
			addEventListener(Event.ADDED, onInit);
			_children.addEventListener(ListEvent.LIST_CHANGE, onChildrenChange);
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
		
		override public function get width():Number
		{
			return displayWidth * scaleX;
		}
		override public function set width(value:Number):void
		{
			displayWidth = value / scaleY;
		}
		
		override public function get height():Number
		{
			return displayHeight * scaleY;
		}
		override public function set height(value:Number):void
		{
			displayHeight = value / scaleY;
		}
		
		
		public function get displayWidth():Number
		{
			return block.displayWidth;
		}
		public function set displayWidth(value:Number):void
		{
			block.displayWidth = value;
		}
		
		public function get displayHeight():Number
		{
			return block.displayHeight;
		}
		public function set displayHeight(value:Number):void
		{
			block.displayHeight = value;
		}
		
		public function get snapToPixel():Boolean
		{
			return block.snapToPixel;
		}
		public function set snapToPixel(value:Boolean):void
		{
			block.snapToPixel = value;
		}
		
		
		public function get layout():ILayoutAlgorithm
		{
			return block.algorithm;
		}
		public function set layout(value:ILayoutAlgorithm):void
		{
			block.algorithm = value;
		}
		
		public function get bounds():Bounds
		{
			return block.bounds;
		}
		public function set bounds(value:Bounds):void
		{
			block.bounds = value;
		}
		
		public function get margin():Box
		{
			return block.margin;
		}
		public function set margin(value:*):void
		{
			block.margin = value;
		}
		
		[Bindable("paddingChange")]
		public function get padding():Box
		{
			return block.padding;
		}
		public function set padding(value:*):void
		{
			var oldValue:Object = block.padding;
			block.padding = value;
			PropertyEvent.dispatchChange(this, "padding", oldValue, block.padding);
		}
		
		public function get anchor():Box
		{
			return block.anchor;
		}
		public function set anchor(value:*):void
		{
			block.anchor = value;
		}
		
		public function get dock():String
		{
			return block.dock;
		}
		public function set dock(value:String):void
		{
			block.dock = value;
		}
		
		public function get tile():String
		{
			return block.tile;
		}
		public function set tile(value:String):void
		{
			block.tile = value;
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
		
		private function onInit(event:Event):void
		{
			block.target = this;
			init();
		}
		
		private function onChildrenChange(event:ListEvent):void
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
		
	}
}