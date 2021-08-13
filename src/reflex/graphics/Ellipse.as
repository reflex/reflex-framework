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
	
	
	public class Ellipse extends GraphicItem implements IGraphicItem //extends GraphicBase implements IDrawable
	{
		
		//public var owner:Object;
		
		//static public const RENDER:String = "render";
		//Invalidation.registerPhase(RENDER, Event, 0);
		
		
		override protected function onLayout():void {
			super.onLayout();
			var g:Graphics = this.display.graphics;
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
				if(width == height) {
					graphics.drawCircle(width/2, width/2, width/2);
				} else {
					graphics.drawEllipse(0, 0, width, height);
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