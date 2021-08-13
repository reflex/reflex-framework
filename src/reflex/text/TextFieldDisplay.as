package reflex.text
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	import reflex.events.DataChangeEvent;
	import reflex.framework.IMeasurable;
	import reflex.framework.IMeasurablePercent;
	//import reflex.measurement.IMeasurements;
	import reflex.framework.IStyleable;
	import reflex.styles.Style;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	public class TextFieldDisplay extends TextField implements IStyleable, IMeasurable, IMeasurablePercent
	{
		
		private var _id:String;
		private var _styleName:String;
		private var _style:Style;
		
		//private var _explicit:IMeasurements;
		//private var _measured:IMeasurements;
		
		private var _explicitWidth:Number;
		private var _explicitHeight:Number;
		protected var _measuredWidth:Number;
		protected var _measuredHeight:Number;
		
		private var _percentWidth:Number;
		private var _percentHeight:Number;
		
		private var _unscaledWidth:Number = 160;
		private var _unscaledHeight:Number = 22;
		
		
		protected function get unscaledWidth():Number { return _unscaledWidth; }
		protected function set unscaledWidth(value:Number):void {
			_unscaledWidth = value;
			super.width = _unscaledWidth;
		}
		
		protected function get unscaledHeight():Number { return _unscaledHeight; }
		protected function set unscaledHeight(value:Number):void {
			_unscaledHeight = value;
			super.height = _unscaledHeight;
		}
		
		public function TextFieldDisplay() {
			super();
			_style = new Style(); // need to make object props bindable - something like ObjectProxy but lighter?
			//_explicit = new Measurements(this);
			//_measured = new Measurements(this, 160, 22);
			_measuredWidth = 160;
			_measuredHeight = 22;
			addEventListener(Event.CHANGE, textChange, false, 0, true);
			addEventListener(Event.CHANGE, onMeasure, false, 0, true);
			//onMeasure(null);
		}
		
		[Bindable(event="textChange", noEvent)]
		override public function get text():String { return super.text; }
		override public function set text(value:String):void {
			if(value == null) { 
				notify("text", super.text, null);
				super.text = "";
			} else {
				notify("text", super.text, super.text = value);
			}
			onMeasure(null);
		}
		
		[Bindable(event="htmlTextChange", noEvent)]
		override public function get htmlText():String { return super.text; }
		override public function set htmlText(value:String):void {
			if(value == null) { 
				notify("htmlText", super.htmlText, null);
				super.htmlText = "";
			} else {
				notify("htmlText", super.htmlText, super.htmlText = value);
			}
			onMeasure(null);
		}
		
		override public function set defaultTextFormat(value:TextFormat):void {
			notify("defaultTextFormat", super.defaultTextFormat, super.defaultTextFormat = value);
			super.text = text;
		}
		
		// IStyleable implementation
		
		[Bindable(event="idChange", noEvent)]
		public function get id():String { return _id; }
		public function set id(value:String):void {
			notify("id", _id, _id = value);
		}
		
		[Bindable(event="styleNameChange", noEvent)]
		public function get styleName():String { return _styleName;}
		public function set styleName(value:String):void {
			notify("styleName", _styleName, _styleName= value);
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
						if(!isNaN( Number(v) )) {
							_style[property] = Number(v);
						} else {
							_style[property] = v;
						}
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
			notify("x", super.x, super.x = value);
		}
		
		[Bindable(event="yChange", noEvent)]
		override public function get y():Number { return super.y; }
		override public function set y(value:Number):void {
			notify("y", super.y, super.y = value);
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
			unscaledWidth = _explicitWidth = value; // this will dispatch for us if needed
			// excluding super to avoid double event dispatch
		}
		
		/**
		 * @inheritDoc
		 */
		[PercentProxy("percentHeight")]
		[Bindable(event="heightChange", noEvent)]
		override public function get height():Number { return unscaledHeight; }
		override public function set height(value:Number):void {
			unscaledHeight  = _explicitHeight = value; // this will dispatch for us if needed (order is important)
			// excluding super to avoid double event dispatch
		}
		
		/**
		 * @inheritDoc
		 */
		//[Bindable(event="explicitChange", noEvent)]
		public function get explicitWidth():Number { return _explicitWidth; }
		public function get explicitHeight():Number { return _explicitHeight; }
		
		/**
		 * @inheritDoc
		 */
		//[Bindable(event="measuredChange", noEvent)]
		public function get measuredWidth():Number { return _measuredWidth; }
		public function get measuredHeight():Number { return _measuredHeight; }
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="percentWidthChange", noEvent)]
		public function get percentWidth():Number { return _percentWidth; }
		public function set percentWidth(value:Number):void {
			notify("percentWidth", _percentWidth, _percentWidth = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="percentHeightChange", noEvent)]
		public function get percentHeight():Number { return _percentHeight; }
		public function set percentHeight(value:Number):void {
			notify("percentHeight", _percentHeight, _percentHeight = value);
		}
		
		[Bindable(event="visibleChange")]
		override public function get visible():Boolean { return super.visible; }
		override public function set visible(value:Boolean):void {
			notify("visible", super.visible, super.visible = value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setSize(width:Number, height:Number):void {
			if (unscaledWidth != width) { notify("width", unscaledWidth, unscaledWidth = width); }
			if (unscaledHeight != height) { notify("height", unscaledHeight, unscaledHeight = height); }
		}
		
		private function textChange(event:Event):void {
			notify("text", null, super.text);
		}
		
		private function onMeasure(event:Event):void {
			if(isNaN(_explicitWidth)) {
				if(type == TextFieldType.INPUT) {
					_measuredWidth = textWidth + 30;
				} else {
					_measuredWidth = textWidth;
				}
			}
			if(isNaN(_explicitHeight)) {
				_measuredHeight = textHeight + 5;
			}
		}
		
		protected function notify(property:String, oldValue:*, newValue:*):void {
			var force:Boolean = false;
			var instance:IEventDispatcher = this;
			if(oldValue != newValue || force) {
				var eventType:String = property + "Change";
				if(instance is IEventDispatcher && (instance as IEventDispatcher).hasEventListener(eventType)) {
					var event:DataChangeEvent = new DataChangeEvent(eventType, oldValue, newValue);
					(instance as IEventDispatcher).dispatchEvent(event);
				}
			}
		}
		
	}
}