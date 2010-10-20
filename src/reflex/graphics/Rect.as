package reflex.graphics
{
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.PropertyChangeEvent;
	import mx.graphics.IFill;
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
	public class Rect extends GraphicBase implements IDrawable
	{
		
		private var _radiusX:Number = 0;
		private var _radiusY:Number = 0;
		
		
		[Bindable(event="radiusXChange")]
		public function get radiusX():Number { return _radiusX; }
		public function set radiusX(value:Number):void {
			DataChange.change(this, "radiusX", _radiusX, _radiusX = value);
		}
		
		[Bindable(event="radiusYChange")]
		public function get radiusY():Number { return _radiusY; }
		public function set radiusY(value:Number):void {
			DataChange.change(this, "radiusY", _radiusY, _radiusY = value);
		}
		
		// topLeftRadiusX
		// topLeftRadiusY
		// topRightRadiusX
		// topRightRadiusY
		// bottomRightRadiusX
		// botomRightRadiusY
		// bottomLeftRadiusX
		// bottomLeftRadiusY
		
		// rect
		
		private var _fill:IFill;
		private var _stroke:IStroke;
		
		[Bindable(event="fillChange")]
		public function get fill():IFill { return _fill; }
		public function set fill(value:IFill):void {
			DataChange.change(this, "fill", _fill, _fill = value);
		}
		
		[Bindable(event="strokeChange")]
		public function get stroke():IStroke { return _stroke; }
		public function set stroke(value:IStroke):void {
			DataChange.change(this, "stroke", _stroke, _stroke = value);
		}
		
		
		public function Rect()
		{
			super();
		}
		
		/**
		 * @private
		 */
		// we need to handle custom fill/stroke properties somehow
		[CommitProperties(target="x, y, width, height, radiusX, radiusY, fill, fill.color, fill.alpha, stroke, stroke.color, stroke.alpha, stroke.weight, target")]
		public function updateRender(event:Event):void {
			render();
		}
		
		public function render():void {
			var graphics:Vector.<Graphics> = reflex.graphics.resolveGraphics(target);
			for each(var g:Graphics in graphics) {
				g.clear(); // will fix this later
				drawTo(g);
			}
		}
		
		private function drawTo(graphics:Graphics):void {
			if(width > 0 && height > 0) {
				var rectangle:Rectangle = new Rectangle(0, 0, width, height);
				if(stroke != null) {
					stroke.apply(graphics, rectangle, new Point());
				} else {
					graphics.lineStyle(0, 0, 0);
				}
				if(fill != null) {
					fill.begin(graphics, rectangle, new Point());
				} else {
					graphics.beginFill(0, 0);
				}
				if(_radiusX > 0 || _radiusY > 0) {
					graphics.drawRoundRect(x, y, width, height, _radiusX, _radiusY);
				} else {
					graphics.drawRect(x, y, width, height);
				}
				if(fill != null) {
					fill.end(graphics);
				} else {
					graphics.endFill();
				}
			}
		}
		
	}
}