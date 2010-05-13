package reflex.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import reflex.events.InvalidationEvent;
	import reflex.measurement.IMeasurable;
	import reflex.measurement.IMeasurements;
	import reflex.measurement.Measurements;
	
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
		
		private var unscaledWidth:Number;
		private var unscaledHeight:Number;
		private var _measurements:IMeasurements = new Measurements();
		
		[Bindable(event="xChange")]
		override public function get x():Number { return super.x; }
		override public function set x(value:Number):void {
			if (super.x == value) {
				return;
			}
			super.x = value;
			dispatchEvent( new Event("xChange") );
		}
		
		[Bindable(event="yChange")]
		override public function get y():Number { return super.y; }
		override public function set y(value:Number):void {
			if (super.y == value) {
				return;
			}
			super.y = value;
			dispatchEvent( new Event("yChange") );
		}
		
		// these width/height setters need review in regards to scaling.
		// I think I would perfer following Flex's lead here.
		
		[Bindable(event="widthChange")]
		override public function get width():Number {
			return unscaledWidth * scaleX;
		}
		override public function set width(value:Number):void {
			unscaledWidth = value / scaleX;
			_measurements.expliciteWidth = unscaledWidth;
			dispatchEvent( new Event("widthChange") );
		}
		
		
		[Bindable(event="heightChange")]
		override public function get height():Number {
			return unscaledHeight * scaleY;
		}
		override public function set height(value:Number):void {
			unscaledHeight = value / scaleY;
			_measurements.expliciteHeight = unscaledHeight;
			dispatchEvent( new Event("heightChange") );
		}
		
		public function get measurements():IMeasurements { return _measurements; }
		public function set measurements(value:IMeasurements):void {
			if(value != null) { // must not be null
				_measurements = value;
			}
		}
		
		/**
		 * Sets width and height properties without effecting measurement.
		 * Use cases include layout and animation/tweening among other things.
		 */
		public function setSize(width:Number, height:Number):void {
			unscaledWidth = width / scaleX;
			unscaledHeight = height / scaleY;
			dispatchEvent( new Event("widthChange") );
			dispatchEvent( new Event("heightChange") );
		}
		
	}
}