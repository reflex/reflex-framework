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
	
	import reflex.binding.DataChange;
	import reflex.invalidation.Invalidation;
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
	public class Ellipse extends GraphicBase implements IDrawable
	{
		
		static public const RENDER:String = "render";
		Invalidation.registerPhase(RENDER, 0);
		
		private var _fill:IFill;
		private var _stroke:IStroke;
		
		[Bindable(event="fillChange")]
		public function get fill():IFill { return _fill; }
		public function set fill(value:IFill):void {
			var fillDispatcher:IEventDispatcher = _fill as IEventDispatcher;
			if(fillDispatcher) {
				fillDispatcher.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, fillChangeHandler, false);
			}
			DataChange.change(this, "fill", _fill, _fill = value);
			fillDispatcher = _fill as IEventDispatcher;
			if(fillDispatcher) {
				fillDispatcher.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, fillChangeHandler, false, 0, true);
			}
			Invalidation.invalidate(target as DisplayObject, RENDER);
		}
		
		[Bindable(event="strokeChange")]
		public function get stroke():IStroke { return _stroke; }
		public function set stroke(value:IStroke):void {
			var strokeDispatcher:IEventDispatcher = _stroke as IEventDispatcher;
			if(strokeDispatcher) {
				strokeDispatcher.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, strokeChangeHandler, false);
			}
			DataChange.change(this, "stroke", _stroke, _stroke = value);
			strokeDispatcher = _stroke as IEventDispatcher;
			if(strokeDispatcher) {
				strokeDispatcher.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, strokeChangeHandler, false, 0, true);
			}
			Invalidation.invalidate(target as DisplayObject, RENDER);
		}
		
		
		public function Ellipse()
		{
			super();
			this.addEventListener(RENDER, renderHandler, false, 0, true);
		}
		
		/**
		 * @private
		 */
		// we need to handle custom fill/stroke properties somehow
		[Commit(properties="x, y, width, height, radiusX, radiusY, fill, fill.color, fill.alpha, stroke, stroke.color, stroke.alpha, stroke.weight, target")]
		public function updateRender(event:Event):void {
			render();
		}
		
		private function fillChangeHandler(event:Event):void {
			//render();
			Invalidation.invalidate(target as DisplayObject, RENDER);
		}
		
		private function strokeChangeHandler(event:Event):void {
			//render();
			Invalidation.invalidate(target as DisplayObject, RENDER);
		}
		
		private function renderHandler(event:Event):void {
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
				if(width == height) {
					graphics.drawCircle(x+width/2, y+width/2, width/2);
				} else {
					graphics.drawEllipse(x, y, width, height);
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