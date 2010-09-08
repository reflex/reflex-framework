package reflex.display
{
	import reflex.events.PropertyEvent;
	import reflex.measurement.IMeasurable;
	import reflex.measurement.IMeasurablePercent;
	import reflex.measurement.IMeasurements;
	import reflex.measurement.Measurements;
	import reflex.styles.IStyleable;
	
	[PercentProxy("percentWidth")]
	[PercentProxy("percentHeight")]
	
	/**
	 * Provides explicite, implicite, and percent based measurement properties as well as a light-weight styling system.
	 * Although most display classes in Reflex extend Display, it's not referenced directly by the framework itself. 
	 * In other words, you are not required to extend this class to use Reflex!
	 * 
	 * @alpha
	 */
	public class Display extends BindableSprite implements IStyleable, IMeasurable, IMeasurablePercent
	{
		
		private var _id:String;
		private var _styleName:String;
		private var _style:Object;
		
		private var _explicite:IMeasurements;
		private var _measured:IMeasurements;
		
		private var _percentWidth:Number;
		private var _percentHeight:Number;
		
		protected var unscaledWidth:Number = 160;
		protected var unscaledHeight:Number = 22;
		
		public function Display() {
			_style = new Object(); // need to make object props bindable - something like ObjectProxy but lighter?
			_explicite = new Measurements(this, NaN, NaN);
			_measured = new Measurements(this, 160, 22);
		}
		
		
		// IStyleable implementation
		
		[Bindable(event="idChange")]
		public function get id():String { return _id; }
		public function set id(value:String):void {
			if(_id == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "id", _id, _id = value);
		}
		
		[Bindable(event="styleNameChange")]
		public function get styleName():String { return _styleName;}
		public function set styleName(value:String):void {
			if(_styleName == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "styleName", _styleName, _styleName= value);
		}
		
		[Bindable(event="styleChange")]
		public function get style():Object { return _style; }
		public function set style(value:*):void { // this needs expanding in the future
			if(value is String) {
				var token:String = value as String;
				var assignments:Array = token.split(";");
				for each(var assignment:String in assignments) {
					var split:Array = assignment.split(":");
					if(split.length == 2) {
						var property:String = split[0].replace(/\s+/g, "");
						var v:String = split[1].replace(/\s+/g, "");
						_style[property] = v;
					}
				}
			}
		}
		
		public function getStyle(property:String):* {
			return style[property];
		}
		
		public function setStyle(property:String, value:*):void {
			style[property] = value;
		}
		
		
		// IMeasurable implementation
		
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
		
		/**
		 * @inheritDoc
		 */
		public function setSize(width:Number, height:Number):void {
			if(unscaledWidth != width) { PropertyEvent.dispatchChange(this, "width", unscaledWidth, unscaledWidth = width); }
			if(unscaledHeight != height) { PropertyEvent.dispatchChange(this, "height", unscaledHeight, unscaledHeight = height); }
		}
		
	}
}