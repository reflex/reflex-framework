package reflex.graphics
{
	import __AS3__.vec.Vector;
	
	import flash.display.Graphics;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	import mx.events.PropertyChangeEvent;
	// TODO: create a reflex IFill and IStroke - Flex3 & Flex4 Interfaces are incompatible
//	import mx.graphics.IFill;
//	import mx.graphics.IStroke;
	
	import reflex.utils.GraphicsUtil;
	
	public class Rect implements IDrawable
	{
		
		public var x:Number;
		public var y:Number;
		
		private var _width:Number;
		public function get width():Number { return _width; }
		public function set width(value:Number):void {
			_width = value;
			render(); // add invalidation later
		}
		
		private var _height:Number;
		public function get height():Number { return _height; }
		public function set height(value:Number):void {
			_height = value;
			render();
		}
		
		// TODO: create a reflex IFill and IStroke - Flex3 & Flex4 Interfaces are incompatible
		private var _fill:*;
		public function get fill():* { return _fill; }
		public function set fill(value:*):void {
			_fill = value;
			// update this to use binding correctly
			(_fill as IEventDispatcher).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler);
			render();
		}
		
		// TODO: create a reflex IFill and IStroke - Flex3 & Flex4 Interfaces are incompatible
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
		}
		
		public function Rect(target:Object = null)
		{
			this.target = target;
		}
		
		public function render():void {
			var graphics:Vector.<Graphics> = GraphicsUtil.resolveGraphics(target);
			for each(var g:Graphics in graphics) {
				drawTo(g);
			}
		}
		
		private function drawTo(graphics:Graphics):void {
			if(width > 0 && height > 0) {
				var rectangle:Rectangle = new Rectangle(0, 0, width, height);
				if(stroke != null) { stroke.apply(graphics); }
				if(fill != null) { fill.begin(graphics, rectangle); }
				graphics.drawRect(x, y, width, height);
				if(fill != null) { fill.end(graphics); }
			}
		}
		
		private function propertyChangeHandler(event:PropertyChangeEvent):void {
			render();
		}
		
	}
}