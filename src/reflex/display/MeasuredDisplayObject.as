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
		
	/**
	 * Modifies common DisplayObject properties for improved usability.
	 * For instance width and height properties will not be be affected by graphics API updates.
	 * Better naming options are welcome for this class.
	 * @alpha
	 */
	public class MeasuredDisplayObject extends Sprite implements IMeasurable
	{
		
		protected var unscaledWidth:Number = 160;
		protected var unscaledHeight:Number = 22;
		
		private var _explicite:IMeasurements;
		private var _measured:IMeasurements;
		
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
			_explicite.width = value;
			PropertyEvent.dispatchChange(this, "width", unscaledWidth, unscaledWidth = value);
		}
		
		
		[Bindable(event="heightChange")]
		override public function get height():Number { return unscaledHeight; }
		override public function set height(value:Number):void {
			if(unscaledHeight == value) {
				return;
			}
			_explicite.height = value;
			PropertyEvent.dispatchChange(this, "height", unscaledHeight, unscaledHeight = value);
		}
		
		[Bindable(event="expliciteChange")]
		public function get explicite():IMeasurements { return _explicite; }
		/*public function set explicite(value:IMeasurements):void {
			if(_explicite== value) {
				return;
			}
			if(value != null) { // must not be null
				PropertyEvent.dispatchChange(this, "explicite", _explicite, _explicite = value);
			}
		}*/
		
		[Bindable(event="measuredChange")]
		public function get measured():IMeasurements { return _measured; }
		/*public function set measured(value:IMeasurements):void {
			if(_measured== value) {
				return;
			}
			if(value != null) { // must not be null
				PropertyEvent.dispatchChange(this, "measured", _measured, _measured = value);
			}
		}*/
		
		public function MeasuredDisplayObject():void {
			super();
			_explicite = new Measurements(this, NaN, NaN);
			_measured = new Measurements(this, 160, 22);
		}
		
		// design work
		
		/**
		 * Sets width and height properties without effecting measurement.
		 * Use cases include layout and animation/tweening among other things.
		 */
		public function setSize(width:Number, height:Number):void {
			PropertyEvent.dispatchChange(this, "width", unscaledWidth, unscaledWidth = width);
			PropertyEvent.dispatchChange(this, "height", unscaledHeight, unscaledHeight = height);
		}
		
	}
}