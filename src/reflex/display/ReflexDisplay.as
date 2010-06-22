package reflex.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flight.events.PropertyEvent;
	
	import reflex.events.InvalidationEvent;
	import reflex.measurement.IMeasurable;
	import reflex.measurement.IMeasurements;
	import reflex.measurement.Measurements;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	
	import mx.containers.Canvas;
	
	/**
	 * Modifies common DisplayObject properties for improved usability.
	 * For instance width and height properties will not be be affected by graphics API updates.
	 * Better naming options are welcome for this class.
	 * @alpha
	 */
	public class ReflexDisplay extends Sprite implements IMeasurable
	{
		
		// we might consider splitting measurement into
		// a MeasuredDisplay class later.
		
		protected var unscaledWidth:Number = 160;
		protected var unscaledHeight:Number = 22;
		
		private var _measurements:IMeasurements = new Measurements();
		
		[Bindable(event="xChange")]
		override public function get x():Number { return super.x; }
		override public function set x(value:Number):void {
			if (super.x == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "x", super.x, super.x = value);
		}
		
		[Bindable(event="yChange")]
		override public function get y():Number { return super.y; }
		override public function set y(value:Number):void {
			if (super.y == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "y", super.y, super.y = value);
		}
		
		// these width/height setters need review in regards to scaling.
		// I think I would perfer following Flex's lead here.
		
		[Bindable(event="widthChange")]
		override public function get width():Number { return unscaledWidth; }
		override public function set width(value:Number):void {
			if(unscaledWidth == value) {
				return;
			}
			_measurements.expliciteWidth = value;
			PropertyEvent.dispatchChange(this, "width", unscaledWidth, unscaledWidth = value);
		}
		
		
		[Bindable(event="heightChange")]
		override public function get height():Number { return unscaledHeight; }
		override public function set height(value:Number):void {
			if(unscaledHeight == value) {
				return;
			}
			_measurements.expliciteHeight = value;
			PropertyEvent.dispatchChange(this, "height", unscaledHeight, unscaledHeight = value);
		}
		
		/*
		[Bindable(event="widthChange")]
		public function set actualWidth(value:Number):void {
			if(unscaledWidth == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "widthChange", unscaledWidth, unscaledWidth = value);
		}
		
		[Bindable(event="heightChange")]
		public function set actualHeight(value:Number):void {
			if(unscaledHeight == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "heightChange", unscaledHeight, unscaledHeight = value);
		}
		*/
		[Bindable(event="measurementsChange")]
		public function get measurements():IMeasurements { return _measurements; }
		public function set measurements(value:IMeasurements):void {
			if(_measurements == value) {
				return;
			}
			if(value != null) { // must not be null
				PropertyEvent.dispatchChange(this, "measurements", _measurements, _measurements = value);
			}
		}
		
		// design work
		
		/**
		 * Sets width and height properties without effecting measurement.
		 * Use cases include layout and animation/tweening among other things.
		 */
		public function setSize(width:Number, height:Number):void {
			//unscaledWidth = width;
			//unscaledHeight = height;
			PropertyEvent.dispatchChange(this, "width", unscaledWidth, unscaledWidth = width);
			PropertyEvent.dispatchChange(this, "height", unscaledHeight, unscaledHeight = height);
		}
		
	}
}