package reflex.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.events.StyleEvent;
	
	import reflex.events.DataChangeEvent;
	import reflex.injection.IReflexInjector;
	import reflex.invalidation.IReflexInvalidation;
	import reflex.invalidation.LifeCycle;
	import reflex.measurement.IMeasurable;
	import reflex.measurement.IMeasurablePercent;
	import reflex.measurement.IMeasurements;
	import reflex.styles.IStyleable;
	import reflex.styles.Style;
	
	
	/**
	 * Provides explicit, implicit, and percent based measurement properties as well as a light-weight styling system.
	 * Although most display classes in Reflex extend Display, it's not referenced directly by the framework itself. 
	 * In other words, you are not required to extend this class to use Reflex!
	 * 
	 * @alpha
	 */
	public class MeasurableItem extends PropertyDispatcher implements IStyleable, IMeasurable, IMeasurablePercent
	{
		
		private var _id:String;
		private var _styleName:String;
		private var _style:Style;
		
		private var _explicitWidth:Number;
		private var _explicitHeight:Number;
		protected var _measuredWidth:Number;
		protected var _measuredHeight:Number;
		
		private var _percentWidth:Number;
		private var _percentHeight:Number;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		protected var unscaledWidth:Number = 160;
		protected var unscaledHeight:Number = 22;
		
		private var _visible:Boolean = true;
		
		private var _invalidation:IReflexInvalidation;
		
		protected var helper:IDisplayHelper = new FlashDisplayHelper();
		
		private var _display:Object;// = new Sprite();
		
		
		public function get display():Object { return _display; }
		public function set display(value:Object):void {
			_display = value;
		}
		
		public function MeasurableItem() {
			_style = new Style(); // need to make object props bindable - something like ObjectProxy but lighter?
			addEventListener(LifeCycle.INITIALIZE, initialize);
		}
		
		[Bindable(event="invalidationChange")]
		public function get invalidation():IReflexInvalidation { return _invalidation; }
		public function set invalidation(value:IReflexInvalidation):void {
			_invalidation = value;
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
				reflex.styles.parseStyles(_style, token);
			} else {
				throw new Error("BitmapDisplay.set style() does not currently accept a parameter of type: " + value);
			}
		}
		
		public function getStyle(property:String):* {
			return style[property];
		}
		
		public function setStyle(property:String, value:*):void {
			//style[property] = value;
			//DataChange.change(this, property, style[property], style[property] = value);
			// hasEventListener is stopping dispatch for styles ???
			var eventType:String = property + "Change";
			var event:DataChangeEvent = new DataChangeEvent(eventType, style[property], style[property] = value);
			this.dispatchEvent(event);
		}
		
		[Bindable(event="xChange", noEvent)]
		public function get x():Number { return _x; }
		public function set x(value:Number):void {
			if(display) { display.x = value; }
			notify("x", _x, _x = value);
		}
		
		[Bindable(event="yChange", noEvent)]
		public function get y():Number { return _y; }
		public function set y(value:Number):void {
			if(display) { display.y = value; }
			notify("y", _y, _y = value);
		}
		
		// IMeasurable implementation
		
		// these width/height setters need review in regards to scaling.
		// I think I would perfer following Flex's lead here.
		
		/**
		 * @inheritDoc
		 */
		[PercentProxy("percentWidth")]
		[Bindable(event="widthChange", noEvent)]
		public function get width():Number { return unscaledWidth; }
		public function set width(value:Number):void {
			unscaledWidth = _explicitWidth = value;
			setSize(unscaledWidth, height);
		}
		
		/**
		 * @inheritDoc
		 */
		[PercentProxy("percentHeight")]
		[Bindable(event="heightChange", noEvent)]
		public function get height():Number { return unscaledHeight; }
		public function set height(value:Number):void {
			unscaledHeight  = _explicitHeight = value;
			setSize(width, unscaledHeight);
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
		[Bindable(event="percentHeightChange", noEvent, noEvent)]
		public function get percentHeight():Number { return _percentHeight; }
		public function set percentHeight(value:Number):void {
			notify("percentHeight", _percentHeight, _percentHeight = value);
		}
		
		[Bindable(event="visibleChange")]
		public function get visible():Boolean { return _visible; }
		public function set visible(value:Boolean):void {
			notify("visible", _visible, _visible = value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setSize(width:Number, height:Number):void {
			if (unscaledWidth != width) { notify("width", unscaledWidth, unscaledWidth = width); }
			if (unscaledHeight != height) { notify("height", unscaledHeight, unscaledHeight = height); }
		}
		
		protected function invalidate(phase:String):void {
			if(invalidation) { invalidation.invalidate(this, phase); }
		}
		
		protected function initialize(event:Event):void {
			addEventListener(LifeCycle.INVALIDATE, commit, false, 0, true);
			addEventListener(LifeCycle.MEASURE, onMeasure, false, 0, true);
			addEventListener(LifeCycle.LAYOUT, onLayout, false, 0, true);
			
			_invalidation.invalidate(this, LifeCycle.INVALIDATE);
			_invalidation.invalidate(this, LifeCycle.MEASURE);
			_invalidation.invalidate(this, LifeCycle.LAYOUT);
			commit(null);
		}
		
		protected function commit(event:Event):void {
			
		}
		
		protected function onMeasure(event:Event):void {
			
		}
		
		protected function onLayout(event:Event):void {
			
		}
		
	}
}