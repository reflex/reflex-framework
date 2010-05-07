package reflex.text
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextExtent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	import flight.binding.Bind;
	import flight.observers.PropertyChange;
	
	import mx.events.ScrollEvent;
	
	import reflex.events.InvalidationEvent;
	import reflex.layout.Block;
	import reflex.layout.Bounds;
	import reflex.layout.Box;
	import reflex.layout.ILayoutAlgorithm;
	import reflex.layout.LayoutWrapper;
	
	
	public class Text extends TextField
	{
		public static const TEXT_CHANGE:String = "textChange";
		InvalidationEvent.registerPhase(TEXT_CHANGE, 0x90); // before measure
		
		[Bindable]
		public var freeform:Boolean = false;
		
		public var block:Block;
		
		protected var offsetY:Number = 0;
		protected var _lineHeight:Number;
		protected var format:TextFormat;
		
		
		public function Text()
		{
			format = defaultTextFormat;
			antiAliasType = AntiAliasType.ADVANCED;
			background = true;
			backgroundColor = 0xeeeeee;
			multiline = true;
			
			initLayout();
			updateDefaultSize();
			addEventListener(Event.ADDED, onInit);
			addEventListener(LayoutWrapper.LAYOUT, onRender);
			
			addEventListener(Event.CHANGE, onChange);
			addEventListener(TEXT_CHANGE, onTextChange);
		}
		
		private function onChange(event:Event):void
		{
			InvalidationEvent.invalidate(this, TEXT_CHANGE);
		}
		
		private function onTextChange(event:InvalidationEvent):void
		{
			updateDefaultSize();
		}
		
		protected function updateDefaultSize():void
		{
			block.defaultWidth = Math.ceil(textWidth) + 4; // gutter is 2px all around
			block.defaultHeight = Math.ceil(textHeight) + 4;
			scrollH = 0;
		}
		
		public function get editable():Boolean
		{
			return type == TextFieldType.INPUT;
		}
		
		public function set editable(value:Boolean):void
		{
			if (value == (type == TextFieldType.INPUT)) return;
			var change:PropertyChange = PropertyChange.begin();
			value = change.add(this, "editable", (type == TextFieldType.INPUT), value);
			type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			change.commit();
		}
		
		public function get lineHeight():Number
		{
			if (isNaN(_lineHeight)) {
				var metrics:TextLineMetrics = getLineMetrics(0);
				return Math.round(metrics.ascent + metrics.descent + metrics.leading);
			} else {
				return _lineHeight;
			}
		}
		
		public function set lineHeight(value:Number):void
		{
			var change:PropertyChange = PropertyChange.begin();
			_lineHeight = change.add(this, "lineHeight", _lineHeight, value);
			
			if (change.hasChanged()) {
				if (isNaN(_lineHeight)) {
					format.leading = 0;
					super.y = y;
					defaultTextFormat = format;
					setTextFormat(format);
				} else {
					updateLineHeight();
				}
			}
			change.commit();
		}
		
		protected function updateLineHeight():void
		{
			if (isNaN(_lineHeight)) return;
			
			var fixing:Boolean;
			if (text == "") {
				fixing = true;
				text = " ";
			}
			
			var metrics:TextLineMetrics = getLineMetrics(0);
			format.leading = _lineHeight - metrics.ascent - metrics.descent;
			offsetY = Number(format.leading)/2;
			super.y = y + offsetY;
			defaultTextFormat = format;
			setTextFormat(format);
			
			if (fixing) {
				text = "";
			}
		}
		
		override public function set text(value:String):void
		{
			super.text = value;
			InvalidationEvent.invalidate(this, TEXT_CHANGE);
		}
		
		override public function set htmlText(value:String):void
		{
			super.htmlText = value;
			InvalidationEvent.invalidate(this, TEXT_CHANGE);
		}
		
		public function get font():String
		{
			return format.font;
		}
		
		public function set font(value:String):void
		{
			if (value == format.font) return;
			format.font = value;
			defaultTextFormat = format;
			setTextFormat(format);
			updateLineHeight();
		}
		
		public function get size():Number
		{
			return format.size as Number;
		}
		
		public function set size(value:Number):void
		{
			if (value == format.size) return;
			format.size = value;
			defaultTextFormat = format;
			setTextFormat(format);
			updateLineHeight();
		}
		
		public function get color():uint
		{
			return format.color as uint;
		}
		
		public function set color(value:uint):void
		{
			if (value == format.color) return;
			format.color = value;
			defaultTextFormat = format;
			setTextFormat(format);
		}
		
		public function get bold():Boolean
		{
			return format.bold as Boolean;
		}
		
		public function set bold(value:Boolean):void
		{
			if (value == format.bold) return;
			format.bold = value;
			defaultTextFormat = format;
			
		}
		
		public function get italic():Boolean
		{
			return format.italic;
		}
		
		public function set italic(value:Boolean):void
		{
			if (value == format.italic) return;
			format.italic = value;
			defaultTextFormat = format;
			setTextFormat(format);
		}
		
		public function get underline():Boolean
		{
			return format.underline;
		}
		
		public function set underline(value:Boolean):void
		{
			if (value == format.underline) return;
			format.underline = value;
			defaultTextFormat = format;
			setTextFormat(format);
		}
		
		public function get align():String
		{
			return format.align;
		}
		
		public function set align(value:String):void
		{
			if (value == format.align) return;
			format.align = value;
			defaultTextFormat = format;
			setTextFormat(format);
		}
		
		[Bindable(event="xChange")]
		override public function get x():Number
		{
			return super.x;
		}
		override public function set x(value:Number):void
		{
			if (super.x == value) {
				return;
			}
			
			super.x = value;
			block.x = value;
		}
		
		[Bindable(event="yChange")]
		override public function get y():Number
		{
			return block.y;
		}
		override public function set y(value:Number):void
		{
			if (super.y + offsetY == value) {
				return;
			}
			
			super.y = value + offsetY;
			block.y = value;
		}
		
		[Bindable(event="widthChange")]
		override public function get width():Number
		{
			return displayWidth * scaleX;
		}
		override public function set width(value:Number):void
		{
			displayWidth = value / scaleY;
		}
		
		[Bindable(event="heightChange")]
		override public function get height():Number
		{
			return displayHeight * scaleY;
		}
		override public function set height(value:Number):void
		{
			displayHeight = value / scaleY;
		}
		
		public function get actualWidth():Number
		{
			return super.width;
		}
		
		public function get actualHeight():Number
		{
			return super.height;
		}
		
		
		[Bindable(event="displayWidthChange")]
		public function get displayWidth():Number
		{
			return block.displayWidth;
		}
		public function set displayWidth(value:Number):void
		{
			block.displayWidth = value;
		}
		
		[Bindable(event="displayHeightChange")]
		public function get displayHeight():Number
		{
			return block.displayHeight;
		}
		public function set displayHeight(value:Number):void
		{
			block.displayHeight = value;
		}
		
		[Bindable(event="snapToPixelChange")]
		public function get snapToPixel():Boolean
		{
			return block.snapToPixel;
		}
		public function set snapToPixel(value:Boolean):void
		{
			block.snapToPixel = value;
		}
		
		
		[Bindable(event="layoutChange")]
		public function get layout():ILayoutAlgorithm
		{
			return block.algorithm;
		}
		public function set layout(value:ILayoutAlgorithm):void
		{
			block.algorithm = value;
		}
		
		[Bindable(event="boundsChange")]
		public function get bounds():Bounds
		{
			return block.bounds;
		}
		public function set bounds(value:Bounds):void
		{
			block.bounds = value;
		}
		
		[Bindable(event="marginChange")]
		public function get margin():Box
		{
			return block.margin;
		}
		public function set margin(value:*):void
		{
			block.margin = value;
		}
		
		[Bindable(event="paddingChange")]
		public function get padding():Box
		{
			return block.padding;
		}
		public function set padding(value:*):void
		{
			block.padding = value;
		}
		
		[Bindable(event="anchorChange")]
		public function get anchor():Box
		{
			return block.anchor;
		}
		public function set anchor(value:*):void
		{
			block.anchor = value;
		}
		
		[Bindable(event="dockChange")]
		public function get dock():String
		{
			return block.dock;
		}
		public function set dock(value:String):void
		{
			block.dock = value;
		}
		
		[Bindable(event="alignChange")]
		public function get layoutAlign():String
		{
			return block.align;
		}
		public function set layoutAlign(value:String):void
		{
			block.align = value;
		}
		
		
		
		public function invalidate(children:Boolean = false):void
		{
			block.invalidate(children);
		}
		
		public function validate():void
		{
			block.validate();
		}
		
		protected function init():void
		{
		}
		
		protected function initLayout():void
		{
			block = new Block();
			block.addEventListener("xChange", forwardEvent);
			block.addEventListener("yChange", forwardEvent);
			block.addEventListener("displayWidthChange", forwardEvent);
			block.addEventListener("displayWidthChange", onWidthChange);
			block.addEventListener("displayHeightChange", forwardEvent);
			block.addEventListener("displayHeightChange", onHeightChange);
			block.addEventListener("snapToPixelChange", forwardEvent);
			block.addEventListener("layoutChange", forwardEvent);
			block.addEventListener("boundsChange", forwardEvent);
			block.addEventListener("marginChange", forwardEvent);
			block.addEventListener("paddingChange", forwardEvent);
			block.addEventListener("dockChange", forwardEvent);
			block.addEventListener("alignChange", forwardEvent);
			Bind.addBinding(block, "freeform", this, "freeform", true);
		}
		
		private function onRender(event:Event):void
		{
			super.width = width;
			super.height = height;
		}
		
		private function onInit(event:Event):void
		{
			if (event.target != this) {
				return;
			}
			removeEventListener(Event.ADDED, onInit);
			
			block.target = this;
			init();
		}
		
		private function forwardEvent(event:Event):void
		{
			dispatchEvent(event);
		}
		
		private function onWidthChange(event:Event):void
		{
			dispatchEvent( new Event("widthChange") );
		}
		
		private function onHeightChange(event:Event):void
		{
			dispatchEvent( new Event("heightChange") );
		}
	}
}