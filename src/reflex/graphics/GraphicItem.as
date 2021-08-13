package reflex.graphics
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.events.PropertyChangeEvent;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	
	import reflex.display.MeasurableItem;
	import reflex.invalidation.LifeCycle;
	
	public class GraphicItem extends MeasurableItem
	{
		
		private var _fill:IFill;
		private var _stroke:IStroke;
		
		[Bindable(event="fillChange")]
		public function get fill():IFill { return _fill; }
		public function set fill(value:IFill):void {
			var fillDispatcher:IEventDispatcher = _fill as IEventDispatcher;
			if(fillDispatcher) {
				fillDispatcher.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, fillChangeHandler, false);
			}
			notify("fill", _fill, _fill = value);
			fillDispatcher = _fill as IEventDispatcher;
			if(fillDispatcher) {
				fillDispatcher.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, fillChangeHandler, false, 0, true);
			}
			invalidate(LifeCycle.LAYOUT);
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
		
		override public function setSize(width:Number, height:Number):void {
			super.setSize(width, height);
			//animationType = AnimationType.RESIZE;
			invalidate(LifeCycle.LAYOUT);
		}
		
		private function fillChangeHandler(event:Event):void {
			invalidate(LifeCycle.LAYOUT);
		}
		
		private function strokeChangeHandler(event:Event):void {
			invalidate(LifeCycle.LAYOUT);
		}
		
	}
}