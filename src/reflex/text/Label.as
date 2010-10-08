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
	
	import reflex.display.Display;
	import reflex.invalidation.Invalidation;
	
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	public class Label extends Display
	{
		public static const TEXT_RENDER:String = "textRender";
		private static var textPhase:Boolean = Invalidation.registerPhase(TEXT_RENDER, 0x90, false);
		
		[Bindable]
		public var freeform:Boolean = false;
		
		[Bindable]
		public var editable:Boolean = false;
		
		protected var fontFormat:FontDescription;
		protected var format:ElementFormat;
		protected var textElement:TextElement;
		public var textBlock:TextBlock;
		protected var line:TextLine;
		
		
		public function Label()
		{
			fontFormat = new FontDescription();
			format = new ElementFormat();
			textElement = new TextElement("");
			textBlock = new TextBlock(textElement);
			mouseChildren = false;
			
			initLayout();
			addEventListener(Event.ADDED, onInit);
			addEventListener(TEXT_RENDER, onTextRender);
			
		}
		
		public function get text():String
		{
			return textElement.text;
		}
		
		public function set text(value:String):void
		{
			if (value == textElement.text) return;
			textElement.text = value;
			Invalidation.invalidate(this, TEXT_RENDER);
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
			Invalidation.invalidate(this, TEXT_RENDER);
		}
		
		public function get fontFamily():String
		{
			return fontFormat.fontName;
		}
		
		public function set fontFamily(value:String):void
		{
			if (value == fontFormat.fontName) return;
			fontFormat.fontName = value;
			Invalidation.invalidate(this, TEXT_RENDER);
		}
		
		public function get fontSize():Number
		{
			return format.fontSize;
		}
		
		public function set fontSize(value:Number):void
		{
			if (value == format.fontSize) return;
			format.fontSize = value;
			Invalidation.invalidate(this, TEXT_RENDER);
		}
		
		public function get bold():Boolean
		{
			return fontFormat.fontWeight == FontWeight.BOLD;
		}
		
		public function set bold(value:Boolean):void
		{
			if (value == (fontFormat.fontWeight == FontWeight.BOLD)) return;
			fontFormat.fontWeight = value ? FontWeight.BOLD : FontWeight.NORMAL;
			Invalidation.invalidate(this, TEXT_RENDER);
		}
		
		public function get italic():Boolean
		{
			return fontFormat.fontPosture == FontPosture.ITALIC;
		}
		
		public function set italic(value:Boolean):void
		{
			if (value == (fontFormat.fontPosture == FontPosture.ITALIC)) return;
			fontFormat.fontPosture = value ? FontPosture.ITALIC : FontPosture.NORMAL;
			Invalidation.invalidate(this, TEXT_RENDER);
		}
		
		protected function onTextRender(event:Event):void
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
				line.x = 0;
				line.y = line.height-2;
				addChild(line);
			} else {
			}
			
			setSize(line.width, line.height)
		}
						
		public function invalidate(children:Boolean = false):void
		{
			
		}
		
		public function validate():void
		{
			
		}
		
		
		protected function draw():void
		{
			
		}
		
		protected function init():void
		{
		}
		
		protected function initLayout():void
		{
			
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