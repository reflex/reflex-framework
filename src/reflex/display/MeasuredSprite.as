package reflex.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flight.events.PropertyEvent;
	
	import reflex.events.InvalidationEvent;
	import reflex.measurement.IMeasurable;
	import reflex.measurement.IMeasurablePercent;
	import reflex.measurement.IMeasurements;
	import reflex.measurement.Measurements;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	
	[PercentProxy("percentWidth")]
	[PercentProxy("percentHeight")]
	
	/**
	 * The MeasuredSprite class provides explicite, implicite, and percent based measurement properties.
	 * 
	 * Although most display classes in Reflex extend MeasuredSprite it's not referenced 
	 * directly by the framework itself. In other words, you are not required to extend this class to use Reflex.
	 * 
	 * @alpha
	 */
	public class MeasuredSprite extends BindableSprite implements IMeasurable, IMeasurablePercent
	{
		
		protected var unscaledWidth:Number = 160;
		protected var unscaledHeight:Number = 22;
		
		private var _explicite:IMeasurements;
		private var _measured:IMeasurements;
		
		private var _percentWidth:Number;
		private var _percentHeight:Number;
		
		// these width/height setters need review in regards to scaling.
		// I think I would perfer following Flex's lead here.
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="widthChange")]
		override public function get width():Number { return unscaledWidth; }
		override public function set width(value:Number):void {
			unscaledWidth = _explicite.width = value; // this will dispatch for us if needed
			// excluding super to avoid double event dispatch
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="heightChange")]
		override public function get height():Number { return unscaledHeight; }
		override public function set height(value:Number):void {
			unscaledHeight  = _explicite.height = value; // this will dispatch for us if needed (order is important)
			// excluding super to avoid double event dispatch
		}
		
		/**
		 * @inheritDoc
		 */
		//[Bindable(event="expliciteChange")]
		public function get explicite():IMeasurements { return _explicite; }
		/*public function set explicite(value:IMeasurements):void {
			if(_explicite== value) {
				return;
			}
			if(value != null) { // must not be null
				PropertyEvent.dispatchChange(this, "explicite", _explicite, _explicite = value);
			}
		}*/
		
		/**
		 * @inheritDoc
		 */
		//[Bindable(event="measuredChange")]
		public function get measured():IMeasurements { return _measured; }
		/*public function set measured(value:IMeasurements):void {
			if(_measured== value) {
				return;
			}
			if(value != null) { // must not be null
				PropertyEvent.dispatchChange(this, "measured", _measured, _measured = value);
			}
		}*/
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="percentWidthChange")]
		public function get percentWidth():Number { return _percentWidth; }
		public function set percentWidth(value:Number):void {
			if(_percentWidth == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "percentWidth", _percentWidth, _percentWidth = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="percentHeightChange")]
		public function get percentHeight():Number { return _percentHeight; }
		public function set percentHeight(value:Number):void {
			if(_percentHeight == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "percentHeight", _percentHeight, _percentHeight = value);
		}
		
		public function MeasuredSprite():void {
			super();
			_explicite = new Measurements(this, NaN, NaN);
			_measured = new Measurements(this, 160, 22);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setSize(width:Number, height:Number):void {
			if(unscaledWidth != width) { PropertyEvent.dispatchChange(this, "width", unscaledWidth, unscaledWidth = width); }
			if(unscaledHeight != height) { PropertyEvent.dispatchChange(this, "height", unscaledHeight, unscaledHeight = height); }
		}
		
	}
}