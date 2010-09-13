package reflex.display
{
	import flash.display.Sprite;
	
	import reflex.data.DataChange;
	import reflex.measurement.IMeasurable;
	import reflex.measurement.IMeasurablePercent;
	import reflex.measurement.IMeasurements;
	import reflex.measurement.Measurements;
	import reflex.styles.IStyleable;
	import reflex.styles.Style;
	
	/**
	 * Provides explicit, implicit, and percent based measurement properties as well as a light-weight styling system.
	 * Although most display classes in Reflex extend Display, it's not referenced directly by the framework itself. 
	 * In other words, you are not required to extend this class to use Reflex!
	 * 
	 * @alpha
	 */
	public class Display extends Sprite implements IStyleable, IMeasurable, IMeasurablePercent
	{
		
		private var _id:String;
		private var _styleName:String;
		private var _style:Style;
		private var _explicit:IMeasurements;
		private var _measured:IMeasurements;
		
		private var _percentWidth:Number;
		private var _percentHeight:Number;
		
		protected var unscaledWidth:Number = 160;
		protected var unscaledHeight:Number = 22;
		
		public function Display() {
			_style = new Style(); // need to make object props bindable - something like ObjectProxy but lighter?
			_explicit = new Measurements(this, NaN, NaN);
			_measured = new Measurements(this, 160, 22);
		}
		
		
		// IStyleable implementation
		
		[Bindable(event="idChange", noEvent)]
		public function get id():String { return _id; }
		public function set id(value:String):void {
			DataChange.change(this, "id", _id, _id = value);
		}
		
		[Bindable(event="styleNameChange", noEvent)]
		public function get styleName():String { return _styleName;}
		public function set styleName(value:String):void {
			DataChange.change(this, "styleName", _styleName, _styleName= value);
		}
		
		[Bindable(event="styleChange", noEvent)]
		public function get style():Style { return _style; }
		public function set style(value:*):void { // this needs expanding in the future
			if (value is String) {
				var token:String = value as String;
				var assignments:Array = token.split(";");
				for each(var assignment:String in assignments) {
					var split:Array = assignment.split(":");
					if (split.length == 2) {
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
		
		[Bindable(event="xChange", noEvent)]
		override public function get x():Number { return super.x; }
		override public function set x(value:Number):void {
			DataChange.change(this, "x", super.x, super.x = value);
		}
		
		[Bindable(event="yChange", noEvent)]
		override public function get y():Number { return super.y; }
		override public function set y(value:Number):void {
			DataChange.change(this, "y", super.y, super.y = value);
		}
		
		// IMeasurable implementation
		
		// these width/height setters need review in regards to scaling.
		// I think I would perfer following Flex's lead here.
		
		/**
		 * @inheritDoc
		 */
		[PercentProxy("percentWidth")]
		[Bindable(event="widthChange", noEvent)]
		override public function get width():Number { return unscaledWidth; }
		override public function set width(value:Number):void {
			unscaledWidth = _explicit.width = value; // this will dispatch for us if needed
		}
		
		/**
		 * @inheritDoc
		 */
		[PercentProxy("percentHeight")]
		[Bindable(event="heightChange", noEvent)]
		override public function get height():Number { return unscaledHeight; }
		override public function set height(value:Number):void {
			unscaledHeight  = _explicit.height = value; // this will dispatch for us if needed (order is important)
		}
		
		/**
		 * @inheritDoc
		 */
		//[Bindable(event="explicitChange", noEvent)]
		public function get explicit():IMeasurements { return _explicit; }
		/*public function set explicit(value:IMeasurements):void {
		if (value != null) { // must not be null
		DataChange.change(this, "explicit", _explicit, _explicit = value);
		}
		}*/
		
		/**
		 * @inheritDoc
		 */
		//[Bindable(event="measuredChange", noEvent)]
		public function get measured():IMeasurements { return _measured; }
		/*public function set measured(value:IMeasurements):void {
		if (value != null) { // must not be null
		DataChange.change(this, "measured", _measured, _measured = value);
		}
		}*/
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="percentWidthChange", noEvent)]
		public function get percentWidth():Number { return _percentWidth; }
		public function set percentWidth(value:Number):void {
			DataChange.change(this, "percentWidth", _percentWidth, _percentWidth = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="percentHeightChange", noEvent, noEvent)]
		public function get percentHeight():Number { return _percentHeight; }
		public function set percentHeight(value:Number):void {
			DataChange.change(this, "percentHeight", _percentHeight, _percentHeight = value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setSize(width:Number, height:Number):void {
			if (unscaledWidth != width) { DataChange.change(this, "width", unscaledWidth, unscaledWidth = width); }
			if (unscaledHeight != height) { DataChange.change(this, "height", unscaledHeight, unscaledHeight = height); }
		}
		
	}
}