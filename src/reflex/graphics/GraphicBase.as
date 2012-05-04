package reflex.graphics
{
	import flash.display.Shape;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import reflex.events.DataChangeEvent;
	import reflex.measurement.IMeasurable;
	import reflex.measurement.IMeasurablePercent;
	import reflex.measurement.IMeasurements;
	import reflex.metadata.resolveCommitProperties;
	import reflex.styles.IStyleable;
	import reflex.styles.Style;
	import reflex.styles.parseStyles;
	
	public class GraphicBase extends Shape implements IStyleable, IMeasurable, IMeasurablePercent
	{
		
		protected var unscaledWidth:Number = 0;
		protected var unscaledHeight:Number = 0;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _percentWidth:Number;
		private var _percentHeight:Number;
		//private var _explicit:IMeasurements;
		//private var _measured:IMeasurements;
		
		private var _explicitWidth:Number;
		private var _explicitHeight:Number;
		protected var _measuredWidth:Number;
		protected var _measuredHeight:Number;
		
		private var _id:String;
		private var _styleName:String;
		private var _style:Object;
		
		private var _target:Object;
		
		
		public function GraphicBase():void {
			super();
			_target = this;
			_style = new Style(); // need to make object props bindable - something like ObjectProxy but lighter?
			//_explicit = new Measurements(this, NaN, NaN);
			//_measured = new Measurements(this, 0, 0);
			reflex.metadata.resolveCommitProperties(this);
		}
		
		[Bindable(event="targetChange")]
		public function get target():Object { return _target; }
		public function set target(value:Object):void {
			/*DataChange.change(this, "target", _target, _target = value);
			if(_target != null) { // this needs to handle reassignment better (to clean up old bindings/listeners)
				reflex.metadata.resolveCommitProperties(this);
			}*/
			//_target = this; // will update later
		}
		
		[Bindable(event="xChange")]
		override public function get x():Number { return _x; }
		override public function set x(value:Number):void {
			notify("x", _x, _x = value);
		}
		
		[Bindable(event="yChange")]
		override public function get y():Number { return _y; }
		override public function set y(value:Number):void {
			notify("y", _y, _y = value);
		}
		
		[PercentProxy("percentWidth")]
		[Bindable(event="widthChange")]
		override public function get width():Number { return unscaledWidth; }
		override public function set width(value:Number):void {
			unscaledWidth = _explicitWidth = value;
			setSize(unscaledWidth, height);
		}
		
		[PercentProxy("percentWidth")]
		[Bindable(event="heightChange")]
		override public function get height():Number { return unscaledHeight; }
		override public function set height(value:Number):void {
			unscaledHeight  = _explicitHeight = value;
			setSize(width, unscaledHeight);
		}
		
		
		
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
		[Bindable(event="percentHeightChange", noEvent, noEvent)]
		public function get percentHeight():Number { return _percentHeight; }
		public function set percentHeight(value:Number):void {
			notify("percentHeight", _percentHeight, _percentHeight = value);
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
		
		public function setSize(width:Number, height:Number):void {
			if (unscaledWidth != width) { notify("width", unscaledWidth, unscaledWidth = width); }
			if (unscaledHeight != height) { notify("height", unscaledHeight, unscaledHeight = height); }
		}
		
		// IStyleable implementation
		
		[Bindable(event="idChange")]
		public function get id():String { return _id; }
		public function set id(value:String):void {
			notify("id", _id, _id = value);
		}
		
		[Bindable(event="styleNameChange")]
		public function get styleName():String { return _styleName;}
		public function set styleName(value:String):void {
			notify("styleName", _styleName, _styleName= value);
		}
		
		[Bindable(event="styleChange")]
		public function get style():Object { return _style; }
		public function set style(value:*):void { // this needs expanding in the future
			if(value is String) {
				var token:String = value as String;
				reflex.styles.parseStyles(_style, token);
			} else {
				throw new Error("BitmapDisplay.set style() does not currently accept a parameter of type: " + value);
			}
		}
		
		public function getStyle(property:String):* {
			return style[property];
		}
		
		public function setStyle(property:String, value:*):void {
			style[property] = value;
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