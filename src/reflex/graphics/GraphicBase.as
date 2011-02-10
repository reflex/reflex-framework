package reflex.graphics
{
	import flash.display.Shape;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import reflex.binding.DataChange;
	import reflex.measurement.IMeasurable;
	import reflex.measurement.IMeasurablePercent;
	import reflex.measurement.IMeasurements;
	import reflex.measurement.Measurements;
	import reflex.metadata.resolveCommitProperties;
	import reflex.styles.IStyleable;
	import reflex.styles.Style;
	
	public class GraphicBase extends Shape implements IStyleable, IMeasurable, IMeasurablePercent
	{
		
		protected var unscaledWidth:Number = 0;
		protected var unscaledHeight:Number = 0;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _percentWidth:Number;
		private var _percentHeight:Number;
		private var _explicit:IMeasurements;
		private var _measured:IMeasurements;
		
		private var _id:String;
		private var _styleName:String;
		private var _style:Object;
		
		private var _target:Object;
		
		public function GraphicBase():void {
			super();
			_target = this;
			_style = new Style(); // need to make object props bindable - something like ObjectProxy but lighter?
			_explicit = new Measurements(this, NaN, NaN);
			_measured = new Measurements(this, 0, 0);
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
			DataChange.change(this, "x", _x, _x = value);
		}
		
		[Bindable(event="yChange")]
		override public function get y():Number { return _y; }
		override public function set y(value:Number):void {
			DataChange.change(this, "y", _y, _y = value);
		}
		
		[PercentProxy("percentWidth")]
		[Bindable(event="widthChange")]
		override public function get width():Number { return unscaledWidth; }
		override public function set width(value:Number):void {
			unscaledWidth = _explicit.width = value; // this will dispatch for us if needed
		}
		
		[PercentProxy("percentWidth")]
		[Bindable(event="heightChange")]
		override public function get height():Number { return unscaledHeight; }
		override public function set height(value:Number):void {
			unscaledHeight  = _explicit.height = value; // this will dispatch for us if needed (order is important)
		}
		
		
		
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
		public function get explicit():IMeasurements { return _explicit; }
		
		/**
		 * @inheritDoc
		 */
		public function get measured():IMeasurements { return _measured; }
		
		public function setSize(width:Number, height:Number):void {
			if (unscaledWidth != width) { DataChange.change(this, "width", unscaledWidth, unscaledWidth = width); }
			if (unscaledHeight != height) { DataChange.change(this, "height", unscaledHeight, unscaledHeight = height); }
		}
		
		// IStyleable implementation
		
		[Bindable(event="idChange")]
		public function get id():String { return _id; }
		public function set id(value:String):void {
			DataChange.change(this, "id", _id, _id = value);
		}
		
		[Bindable(event="styleNameChange")]
		public function get styleName():String { return _styleName;}
		public function set styleName(value:String):void {
			DataChange.change(this, "styleName", _styleName, _styleName= value);
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
		
		
	}
}