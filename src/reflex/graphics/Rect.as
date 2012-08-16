package reflex.graphics
{
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.PropertyChangeEvent;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	
	import reflex.display.MeasurableItem;
	import reflex.framework.IMeasurablePercent;
	import reflex.framework.IStyleable;
	import reflex.invalidation.Invalidation;
	import reflex.invalidation.LifeCycle;
	import reflex.metadata.resolveCommitProperties;
	
	public class Rect extends GraphicItem //extends GraphicBase implements IDrawable
	{
		
		//public var owner:Object;
		
		//static public const RENDER:String = "render";
		//Invalidation.registerPhase(RENDER, Event, 0);
		
		private var _radiusX:Number = 0;
		private var _radiusY:Number = 0;
		
		
		
		[Bindable(event="radiusXChange")]
		public function get radiusX():Number { return _radiusX; }
		public function set radiusX(value:Number):void {
			notify("radiusX", _radiusX, _radiusX = value);
		}
		
		[Bindable(event="radiusYChange")]
		public function get radiusY():Number { return _radiusY; }
		public function set radiusY(value:Number):void {
			notify("radiusY", _radiusY, _radiusY = value);
		}
		
		// topLeftRadiusX
		// topLeftRadiusY
		// topRightRadiusX
		// topRightRadiusY
		// bottomRightRadiusX
		// botomRightRadiusY
		// bottomLeftRadiusX
		// bottomLeftRadiusY
		
		
		
		override protected function onLayout():void {
			super.onLayout();
			var g:Graphics = this.display.graphics;
			//var graphics:Vector.<Graphics> = reflex.graphics.resolveGraphics(target);
			//for each(var g:Graphics in graphics) {
				g.clear(); // will fix this later
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
				if(_radiusX > 0 || _radiusY > 0) {
					graphics.drawRoundRect(0, 0, width, height, _radiusX*2, _radiusY*2);
				} else {
					graphics.drawRect(0, 0, width, height);
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