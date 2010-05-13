package reflex.graphics
{
	import __AS3__.vec.Vector;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.PropertyChangeEvent;
	
	import reflex.events.InvalidationEvent;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	public class Rect extends EventDispatcher implements IDrawable
	{
		
		[Bindable] public var x:Number = 0;
		[Bindable] public var y:Number = 0;
		
		[Bindable] public var style:Object = new Object();
		
		public function setStyle(property:String, value:*):void {
			style[property] = value;
		}
		
		private var _width:Number = 0; [Bindable]
		public function get width():Number { return _width; }
		public function set width(value:Number):void {
			_width = value;
			render(); // add invalidation later
		}
		
		private var _height:Number = 0; [Bindable]
		public function get height():Number { return _height; }
		public function set height(value:Number):void {
			_height = value;
			render();
		}
		
		public function setSize(width:Number, height:Number):void {
			_width = width;
			_height = height;
			render();
		}
		
		private var _fill:*;
		public function get fill():* { return _fill; }
		public function set fill(value:*):void {
			_fill = value;
			// update this to use binding correctly
			(_fill as IEventDispatcher).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
			render();
		}
		
		private var _stroke:*;
		public function get stroke():* { return _stroke; }
		public function set stroke(value:*):void {
			_stroke = value;
			render();
		}
		
		private var _target:Object;
		public function get target():Object { return _target; }
		public function set target(value:Object):void {
			_target = value;
			render();
		}
		
		public function Rect(target:Object = null)
		{
			this.target = target;
		}
		
		public function render():void {
			var graphics:Vector.<Graphics> = reflex.graphics.resolveGraphics(target);
			for each(var g:Graphics in graphics) {
				drawTo(g);
			}
		}
		
		private function drawTo(graphics:Graphics):void {
			if(width > 0 && height > 0) {
				var rectangle:Rectangle = new Rectangle(0, 0, width, height);
				if(stroke != null) { stroke.apply(graphics, rectangle, new Point()); }
				if(fill != null) { fill.begin(graphics, rectangle, new Point()); }
				graphics.drawRect(x, y, width, height);
				if(fill != null) { fill.end(graphics); }
			}
		}
		
		private function propertyChangeHandler(event:PropertyChangeEvent):void {
			render();
		}
		
	}
}