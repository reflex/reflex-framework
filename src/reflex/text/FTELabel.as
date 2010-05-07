package reflex.text
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.RenderingMode;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextLineValidity;
	import flash.text.engine.TypographicCase;
	
	import flight.binding.Bind;
	
	import reflex.events.InvalidationEvent;
	import reflex.layout.Block;
	import reflex.layout.Bounds;
	import reflex.layout.Box;
	import reflex.layout.ILayoutAlgorithm;
	import reflex.layout.LayoutWrapper;
	
	public class FTELabel extends Sprite
	{
		public static const TEXT_RENDER:String = "textRender";
		private static var textPhase:Boolean = InvalidationEvent.registerPhase(TEXT_RENDER, 0x90, false);
		
		[Bindable]
		public var freeform:Boolean = false;
		
		public var block:Block;
		
		
		protected var fontFormat:FontDescription;
		protected var format:ElementFormat;
		protected var textElement:TextElement;
		public var textBlock:TextBlock;
		protected var line:TextLine;
		
		
		public function FTELabel()
		{
			fontFormat = new FontDescription();
			format = new ElementFormat();
			textElement = new TextElement("");
			textBlock = new TextBlock(textElement);
			mouseChildren = false;
			
			initLayout();
			addEventListener(Event.ADDED, onInit);
			addEventListener(TEXT_RENDER, onTextRender);
			addEventListener(LayoutWrapper.LAYOUT, onRender);
		}
		
		public function get text():String
		{
			return textElement.text;
		}
		
		public function set text(value:String):void
		{
			if (value == textElement.text) return;
			textElement.text = value;
			InvalidationEvent.invalidate(this, TEXT_RENDER);
		}
		
		public function get embed():Boolean
		{
			return (fontFormat.fontLookup == FontLookup.EMBEDDED_CFF);
		}
		
		public function set embed(value:Boolean):void
		{
			fontFormat.fontLookup = value ? FontLookup.EMBEDDED_CFF : FontLookup.DEVICE;
		}
		
		public function get color():uint
		{
			return format.color;
		}
		
		public function set color(value:uint):void
		{
			if (value == format.color) return;
			format.color = value;
			InvalidationEvent.invalidate(this, TEXT_RENDER);
		}
		
		public function get fontFamily():String
		{
			return fontFormat.fontName;
		}
		
		public function set fontFamily(value:String):void
		{
			if (value == fontFormat.fontName) return;
			fontFormat.fontName = value;
			InvalidationEvent.invalidate(this, TEXT_RENDER);
		}
		
		public function get fontSize():Number
		{
			return format.fontSize;
		}
		
		public function set fontSize(value:Number):void
		{
			if (value == format.fontSize) return;
			format.fontSize = value;
			InvalidationEvent.invalidate(this, TEXT_RENDER);
		}
		
		public function get bold():Boolean
		{
			return fontFormat.fontWeight == FontWeight.BOLD;
		}
		
		public function set bold(value:Boolean):void
		{
			if (value == (fontFormat.fontWeight == FontWeight.BOLD)) return;
			fontFormat.fontWeight = value ? FontWeight.BOLD : FontWeight.NORMAL;
			InvalidationEvent.invalidate(this, TEXT_RENDER);
		}
		
		public function get italic():Boolean
		{
			return fontFormat.fontPosture == FontPosture.ITALIC;
		}
		
		public function set italic(value:Boolean):void
		{
			if (value == (fontFormat.fontPosture == FontPosture.ITALIC)) return;
			fontFormat.fontPosture = value ? FontPosture.ITALIC : FontPosture.NORMAL;
			InvalidationEvent.invalidate(this, TEXT_RENDER);
		}
		
		protected function onTextRender(event:InvalidationEvent):void
		{
			validateText();
		}
		
		public function validateText():void
		{
			while (numChildren) removeChildAt(0);
			
			format.fontDescription = fontFormat;
			textElement.elementFormat = format;
			format = format.clone();
			fontFormat = fontFormat.clone();
			
			line = textBlock.createTextLine();
			
			if (line) {
				line.x = 2;
				line.y = line.ascent + 2;
				addChild(line);
				block.defaultWidth = Math.round(line.textWidth + 4);
				block.defaultHeight = Math.round(line.textHeight + 4);
			} else {
				block.defaultWidth = 4;
				block.defaultHeight = format.fontSize + 4;
			}
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
			if (super.y == value) {
				return;
			}
			
			super.y = value;
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
		public function get align():String
		{
			return block.align;
		}
		public function set align(value:String):void
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
		
		
		protected function draw():void
		{
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, displayWidth, displayHeight);
			graphics.endFill();
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
			draw();
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