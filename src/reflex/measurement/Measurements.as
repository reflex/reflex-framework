package reflex.measurement
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import flight.events.PropertyEvent;
	
	// might break this up to multiples later
	// ie. measured.height, explicite.minWidth, etc
	
	/**
	 * @alpha
	 */
	public class Measurements implements IMeasurements
	{
		
		private var _width:Number;
		private var _height:Number;
		
		private var _minWidth:Number;
		private var _minHeight:Number;
		
		// should these even be bindable?
		
		private var instance:IMeasurable;
		
		[Bindable]
		public function get width():Number { return _width; }
		public function set width(value:Number):void {
			_width = value;
			if(!(instance.measured== this && !isNaN(instance.explicite.width))) { // measured changes shouldn't update when explicite is set
				instance.setSize(value, instance.height);
			}
		}
		
		[Bindable]
		public function get height():Number { return _height; }
		public function set height(value:Number):void {
			_height = value;
			if(!(instance.measured== this && !isNaN(instance.explicite.height))) { // measured changes shouldn't update when explicite is set
				instance.setSize(instance.width, value); 
			}
		}
		
		[Bindable]
		public function get minWidth():Number { return _minWidth; }
		public function set minWidth(value:Number):void {
			_minWidth = value;
		}
		
		[Bindable]
		public function get minHeight():Number { return _minHeight; }
		public function set minHeight(value:Number):void {
			_minHeight = value;
		}
		
		// 160, 22
		public function Measurements(instance:IMeasurable, defaultWidth:Number = NaN, defaultHeight:Number = NaN) {
			this.instance = instance;
			_width = defaultWidth;
			_height = defaultHeight;
		}
		
	}
}