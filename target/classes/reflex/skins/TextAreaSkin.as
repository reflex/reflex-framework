package reflex.skins
{
	
	import flash.events.Event;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	
	import reflex.components.VSlider;
	import reflex.graphics.Rect;
	import reflex.layouts.BasicLayout;
	import reflex.text.TextFieldDisplay;

	public class TextAreaSkin extends Skin
	{
		
		public var textField:TextFieldDisplay;
		public var verticalScrollBar:VSlider;
		
		public function TextAreaSkin(multiline:Boolean = false)
		{
			super();
			textField = new TextFieldDisplay();
			textField.type = TextFieldType.INPUT;
			textField.multiline = multiline;
			textField.wordWrap = true;
			textField.defaultTextFormat = new TextFormat(null, 24, 0x000000, null, null, null, null, null, TextFormatAlign.JUSTIFY, 0, 0, 0, 0);
			textField.defaultTextFormat.display = "bottom";
			textField.style = "left: 20; right: 0; top: 10; bottom: 5;";
			
			var rect:Rect = new Rect();
			rect.fill = new SolidColor(0xFFFFFF);
			rect.stroke = new SolidColorStroke(0x000000, 2);
			rect.style = "left: 0; right: 0; top: 0; bottom: 0;";
			
			verticalScrollBar = new VSlider();
			verticalScrollBar.style = "right: 0; top: 0; bottom: 0;";
			
			layout = new BasicLayout();
			content.addItem(rect);
			content.addItem(textField);
			content.addItem(verticalScrollBar);
		}
		
		override public function setSize(width:Number, height:Number):void {
			super.setSize(width, height);
			/*
			if(scrollbar && textField && textField.maxScrollV > -1) {
				scrollbar.visible = true;
			} else {
				scrollbar.visible = false;
			}
			*/
		}
		
	}
}