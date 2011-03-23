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
	import flash.text.engine.LineJustification;
	import flash.text.engine.RenderingMode;
	import flash.text.engine.SpaceJustifier;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextJustifier;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextLineValidity;
	import flash.text.engine.TypographicCase;
	
	import reflex.binding.DataChange;
	import reflex.display.Display;
	import reflex.invalidation.Invalidation;
	import reflex.styles.resolveStyle;
	
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	[Style(name="txtAlign", format="String", enumeration="left,right,center,justify")]
	//[Style(name="verticalAlign")]
	public class Label extends Display
	{
		
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const CENTER:String = "center";
		public static const JUSTIFY:String = "justify";
		
		public static const TEXT_RENDER:String = "textRender";
		private static var textPhase:Boolean = Invalidation.registerPhase(TEXT_RENDER, 0, true);
		
		protected var fontFormat:FontDescription;
		protected var format:ElementFormat;
		protected var textElement:TextElement;
		protected var textBlock:TextBlock;
		protected var line:TextLine;
		protected var lineJustifier:SpaceJustifier = new SpaceJustifier("en", LineJustification.UNJUSTIFIED);
		
		protected var _allowWrap:Boolean = false;
		protected var _clipText:Boolean = false;
		
		public function Label(text:String = "")
		{
			fontFormat = new FontDescription();
			format = new ElementFormat(null, 24);
			textElement = new TextElement("");
			textBlock = new TextBlock(textElement);
			mouseChildren = false;
			addEventListener(TEXT_RENDER, onTextRender);
			this.text = text;
		}
		
		[Bindable(event="textChange")]
		public function get text():String { return textElement.text; }
		public function set text(value:String):void {
			if (value == textElement.text) {
				return;
			}
			Invalidation.invalidate(this, TEXT_RENDER);
			DataChange.change(this, "text", textElement.text, textElement.text = value);
		}
		
		[Bindable(event="allowWrapChange")]
		public function get allowWrap():Boolean {
			return _allowWrap;
		}
		public function set allowWrap(value:Boolean):void {
			if(value == _allowWrap) {
				return;
			}
			Invalidation.invalidate(this, TEXT_RENDER);
			DataChange.change(this, "allowWrap", _allowWrap, _allowWrap = value);
		}
		
		[Bindable(event="clipTextChange")]
		public function get clipText():Boolean {
			return _clipText;
		}
		public function set clipText(value:Boolean):void {
			if(value == _clipText) {
				return;
			}
			Invalidation.invalidate(this, TEXT_RENDER);
			DataChange.change(this, "clipText", _clipText, _clipText = value);
		}
		
		[Bindable(event="embedChange")]
		public function get embed():Boolean {
			return (fontFormat.fontLookup == FontLookup.EMBEDDED_CFF);
		}
		public function set embed(value:Boolean):void {
			DataChange.change(this, "embed", fontFormat.fontLookup == FontLookup.EMBEDDED_CFF, fontFormat.fontLookup = value ? FontLookup.EMBEDDED_CFF : FontLookup.DEVICE);
		}
		
		[Bindable(event="colorChange")]
		public function get color():uint { return format.color; }
		public function set color(value:uint):void {
			if (value == format.color) {
				return;
			}
			Invalidation.invalidate(this, TEXT_RENDER);
			DataChange.change(this, "color", format.color, format.color = value);
		}
		
		[Bindable(event="fontFamilyChange")]
		public function get fontFamily():String { return fontFormat.fontName; }
		public function set fontFamily(value:String):void {
			if (value == fontFormat.fontName) {
				return;
			}
			Invalidation.invalidate(this, TEXT_RENDER);
			DataChange.change(this, "fontFamily", fontFormat.fontName, fontFormat.fontName = value);
		}
		
		[Bindable(event="fontSizeChange")]
		public function get fontSize():Number { return format.fontSize; }		
		public function set fontSize(value:Number):void {
			if (value == format.fontSize) {
				return;
			}
			Invalidation.invalidate(this, TEXT_RENDER);
			DataChange.change(this, "fontSize", format.fontSize, format.fontSize = value);
		}
		
		[Bindable(event="boldChange")]
		public function get bold():Boolean {
			return fontFormat.fontWeight == FontWeight.BOLD;
		}		
		public function set bold(value:Boolean):void {
			if (value == (fontFormat.fontWeight == FontWeight.BOLD)) {
				return;
			}
			Invalidation.invalidate(this, TEXT_RENDER);
			DataChange.change(this, "bold", fontFormat.fontWeight == FontWeight.BOLD, fontFormat.fontWeight = value ? FontWeight.BOLD : FontWeight.NORMAL);
		}
		
		[Bindable(event="italicChange")]
		public function get italic():Boolean {
			return fontFormat.fontPosture == FontPosture.ITALIC;
		}
		public function set italic(value:Boolean):void
		{
			if (value == (fontFormat.fontPosture == FontPosture.ITALIC)) {
				return;
			}
			Invalidation.invalidate(this, TEXT_RENDER);
			DataChange.change(this, "italic", fontFormat.fontPosture == FontPosture.ITALIC, fontFormat.fontPosture = value ? FontPosture.ITALIC : FontPosture.NORMAL);
		}
		
		protected function alignText(align:String, line:TextLine):void {
			switch(align) {
				case LEFT:
					line.x = 0;
					break;
				case RIGHT:
					line.x = unscaledWidth-line.textWidth;
					break;
				case CENTER:
					line.x = unscaledWidth/2-line.textWidth/2;
					break;
			}
		}
		
		protected function verticalAlignText(line:TextLine):void {
			line.y = unscaledHeight/2 + line.textHeight/2;
		}
		
		protected function onTextRender(event:Event):void
		{
			
			while (numChildren) removeChildAt(0);
			
			format.fontDescription = fontFormat;
			textElement.elementFormat = format;
			
			format = format.clone();
			fontFormat = fontFormat.clone();
			
			var startY:int = 0;
			var align:String = resolveStyle(this, "txtAlign", String, CENTER) as String;
		
			lineJustifier.lineJustification = (align == JUSTIFY) ? LineJustification.ALL_BUT_LAST : LineJustification.UNJUSTIFIED;
			textBlock.textJustifier = lineJustifier;
			
			if(allowWrap) {
				var l:TextLine = line = textBlock.createTextLine(null, unscaledWidth);
				while(l) {
					startY += l.height;
					l.y = startY;
					alignText(align, l);
					addChild(l);
					l = textBlock.createTextLine(l, unscaledWidth);
				}
				measured.height = startY;
			} else {
				line = textBlock.createTextLine(null, clipText ? unscaledWidth : 100000);
				if(line) {
					measured.width = line.textWidth;
					measured.height = line.textHeight;
					line.y = line.height; //height/2 + line.height/2-3;
					alignText(align, line);
					verticalAlignText(line);
					addChild(line);
				} else {
					measured.width = 0;
					measured.height = 0;
				}
			}
			
		}
		
		
		override public function setSize(width:Number, height:Number):void {
			super.setSize(width, height);
			// we'll need to invalidate seperate measurement and layout passes later
			if(line) {
				if(!allowWrap) {
					verticalAlignText(line);
				}
				var l:TextLine = line;
				var align:String = resolveStyle(this, "txtAlign", String, CENTER) as String;
				while(l) {
					alignText(align, l);
					l = l.nextLine;
				}
				
			}
		}
		
		
	}
}