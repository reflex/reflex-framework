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
	
	import reflex.display.MeasurableItem;
	import reflex.framework.IMeasurablePercent;
	import reflex.framework.IStyleable;
	import reflex.invalidation.LifeCycle;
	import reflex.metadata.resolveCommitProperties;
	
	
	public class Line extends MeasurableItem implements IGraphicItem //GraphicBase implements IDrawable
	{
		
		//public var owner:Object;
		
		private var _xFrom:Number;
		private var _yFrom:Number;
		
		private var _xTo:Number;
		private var _yTo:Number;
		
		private var _stroke:IStroke;
		
		[Bindable(event="xFromChange")]
		public function get xFrom():Number { return isNaN(_xFrom) ? 0 : _xFrom; }
		public function set xFrom(value:Number):void {
			notify("xFrom", _xFrom, _xFrom = value);
		}
		
		[Bindable(event="yFromChange")]
		public function get yFrom():Number { return isNaN(_yFrom) ? 0 : _yFrom }
		public function set yFrom(value:Number):void {
			notify("yFrom", _yFrom, _yFrom = value);
		}
		
		[Bindable(event="xToChange")]
		public function get xTo():Number { return isNaN(_xTo) ? unscaledWidth : _xTo; }
		public function set xTo(value:Number):void {
			notify("xTo", _xTo, _xTo = value);
		}
		
		[Bindable(event="yToChange")]
		public function get yTo():Number { return isNaN(_yTo) ? unscaledHeight : _yTo; }
		public function set yTo(value:Number):void {
			notify("yTo", _yTo, _yTo = value);
		}
		
		
		[Bindable(event="strokeChange")]
		public function get stroke():IStroke { return _stroke; }
		public function set stroke(value:IStroke):void {
			var strokeDispatcher:IEventDispatcher = _stroke as IEventDispatcher;
			if(strokeDispatcher) {
				strokeDispatcher.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, strokeChangeHandler, false);
			}
			notify("stroke", _stroke, _stroke = value);
			strokeDispatcher = _stroke as IEventDispatcher;
			if(strokeDispatcher) {
				strokeDispatcher.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, strokeChangeHandler, false, 0, true);
			}
			invalidate(LifeCycle.LAYOUT);
		}
		
		private function strokeChangeHandler(event:Event):void {
			invalidate(LifeCycle.LAYOUT);
		}
		
		override protected function onLayout():void {
			super.onLayout();
			var g:Graphics = display.graphics;
			//var graphics:Vector.<Graphics> = reflex.graphics.resolveGraphics(target);
			//for each(var g:Graphics in graphics) {
				g.clear(); // fix later
				drawTo(g);
			//}
		}
		
		private function drawTo(graphics:Graphics):void {
			// these should be precalculated later
			var xf:Number = xFrom; // isNaN(xFrom) ? x : xFrom;
			var yf:Number = yFrom; // isNaN(yFrom) ? y : yFrom;
			var xt:Number = xTo; // isNaN(xTo) ? x+width : xTo;
			var yt:Number = yTo; // isNaN(yTo) ? y+height : yTo;
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