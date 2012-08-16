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
	import reflex.framework.IStyleable;
	import reflex.metadata.resolveCommitProperties;
	
	public class Path extends GraphicItem implements IGraphicItem
	{
		
		private var _data:String;
		
		
		[Bindable(event="dataChange")]
		public function get data():String { return _data; }
		public function set data(value:String):void {
			notify("data", _data, _data = value);
		}
		
		
		override protected function onLayout():void {
			super.onLayout();
			var g:Graphics = display.graphics;
			//var graphics:Vector.<Graphics> = reflex.graphics.resolveGraphics(target);
			//for each(var g:Graphics in graphics) {
				g.clear();
				drawTo(g);
			//}
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