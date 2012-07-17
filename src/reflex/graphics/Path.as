package reflex.graphics
{
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.PropertyChangeEvent;
	
	import reflex.framework.IMeasurablePercent;
	import reflex.metadata.resolveCommitProperties;
	import reflex.framework.IStyleable;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	public class Path extends GraphicBase implements IDrawable
	{
		
		private var _data:String;
		
		
		[Bindable(event="dataChange")]
		public function get data():String { return _data; }
		public function set data(value:String):void {
			notify("data", _data, _data = value);
		}
		
		
		private var _fill:*;
		private var _stroke:*;
		
		[Bindable(event="fillChange")]
		public function get fill():* { return _fill; }
		public function set fill(value:*):void {
			notify("fill", _fill, _fill = value);
		}
		
		[Bindable(event="strokeChange")]
		public function get stroke():* { return _stroke; }
		public function set stroke(value:*):void {
			notify("stroke", _stroke, _stroke = value);
		}
		
		
		public function Path()
		{
			super();
		}
		
		/**
		 * @private
		 */
		// we need to handle custom fill/stroke properties somehow
		[Commit(properties="x, y, width, height, data, fill, fill.color, fill.alpha, stroke, stroke.color, stroke.alpha, stroke.weight, target")]
		public function updateRender(event:Event):void {
			render();
		}
		
		public function render():void {
			var graphics:Vector.<Graphics> = reflex.graphics.resolveGraphics(target);
			for each(var g:Graphics in graphics) {
				g.clear();
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
				
				//graphics.drawPath();
				
				if(fill != null) {
					fill.end(graphics);
				} else {
					graphics.endFill();
				}
			}
		}
		
	}
}