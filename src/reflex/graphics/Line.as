package reflex.graphics
{
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.PropertyChangeEvent;
	import mx.graphics.IStroke;
	
	import reflex.binding.DataChange;
	import reflex.measurement.IMeasurablePercent;
	import reflex.metadata.resolveCommitProperties;
	import reflex.styles.IStyleable;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	public class Line extends GraphicBase implements IDrawable
	{
		
		private var _xFrom:Number;
		private var _yFrom:Number;
		
		private var _xTo:Number;
		private var _yTo:Number;
		
		
		[Bindable(event="xFromChange")]
		public function get xFrom():Number { return isNaN(_xFrom) ? x : _xFrom; }
		public function set xFrom(value:Number):void {
			DataChange.change(this, "xFrom", _xFrom, _xFrom= value);
		}
		
		[Bindable(event="yFromChange")]
		public function get yFrom():Number { return isNaN(_yFrom) ? y : _yFrom }
		public function set yFrom(value:Number):void {
			DataChange.change(this, "yFrom", _yFrom, _yFrom = value);
		}
		
		[Bindable(event="xToChange")]
		public function get xTo():Number { return isNaN(_xTo) ? x+width : _xTo; }
		public function set xTo(value:Number):void {
			DataChange.change(this, "xTo", _xTo, _xTo = value);
		}
		
		[Bindable(event="yToChange")]
		public function get yTo():Number { return isNaN(_yTo) ? y+height : _yTo; }
		public function set yTo(value:Number):void {
			DataChange.change(this, "yTo", _yTo, _yTo = value);
		}
		
		
		private var _stroke:IStroke;
		
		[Bindable(event="strokeChange")]
		public function get stroke():IStroke { return _stroke; }
		public function set stroke(value:IStroke):void {
			DataChange.change(this, "stroke", _stroke, _stroke = value);
		}
		
		
		public function Line()
		{
			super();
			//this.measured.width = 1;
			//this.measured.height = 1;
		}
		
		/**
		 * @private
		 */
		// we need to handle custom fill/stroke properties somehow
		[Commit(properties="x, y, width, height, xFrom, yFrom, xTo, yTo, stroke, stroke.color, stroke.alpha, stroke.weight, target")]
		public function updateRender(event:Event):void {
			render();
		}
		
		public function render():void {
			var graphics:Vector.<Graphics> = reflex.graphics.resolveGraphics(target);
			for each(var g:Graphics in graphics) {
				g.clear(); // fix later
				drawTo(g);
			}
		}
		
		private function drawTo(graphics:Graphics):void {
			// these should be precalculated later
			var xf:Number = isNaN(xFrom) ? x : xFrom;
			var yf:Number = isNaN(yFrom) ? y : yFrom;
			var xt:Number = isNaN(xTo) ? x+width : xTo;
			var yt:Number = isNaN(yTo) ? y+height : yTo;
			var rectangle:Rectangle = new Rectangle(0, 0, Math.max(xt-xf, 1), Math.max(yt-yf, 1));
			if(stroke != null) {
				stroke.apply(graphics, rectangle, new Point(xf, yf));
			} else {
				graphics.lineStyle(0, 0, 0);
			}
			graphics.moveTo(xf, yf);
			graphics.lineTo(xt, yt);
		}
		
	}
}