package
{
	import flame.controls.ListBoxGraphic;
	import flame.controls.ScrollBarGraphic;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import reflex.behavior.ButtonBehavior;
	import reflex.behavior.ListBehavior;
	import reflex.behavior.ScrollBehavior;
	import reflex.behavior.SelectableBehavior;
	import reflex.controls.Button;
	import reflex.controls.ListBox;
	import reflex.controls.ScrollBar;
	import reflex.skin.GraphicSkin;
	import reflex.skin.MXMLButtonSkin;
	
	[SWF(widthPercent="100", heightPercent="100", frameRate="15")]
	public class reflex_dev extends Sprite
	{
		private var button:Button;
		private var scrollBar:ScrollBar;
		private var scrollBar2:ScrollBar;
		
		private var listBox:ListBox;
		
		public function reflex_dev()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			button = new Button();
			button.label = "hello world";
			button.x = 30;
			button.y = 30;
			button.skin = new MXMLButtonSkin();
			button.behaviors.buttonState = new ButtonBehavior();
			button.behaviors.selectable = new SelectableBehavior();
			addChild(button);
			
			scrollBar = new ScrollBar();
			scrollBar.x = 30;
			scrollBar.y = 230;
			var gs:ScrollBarGraphic = new ScrollBarGraphic();
			gs.thumb.width = 400;
			scrollBar.skin = new GraphicSkin(gs);
			
			var behavior:ScrollBehavior = new ScrollBehavior();
				behavior.horizontal = true;
			scrollBar.behaviors.scroll = behavior;
			addChild(scrollBar);
			
			
			scrollBar2 = new ScrollBar();
			scrollBar2.rotation = 90;
			scrollBar2.scaleY = -1;
			scrollBar2.x = 230;
			scrollBar2.y = 30;
			scrollBar2.skin = new GraphicSkin(new ScrollBarGraphic());
			var scrollBehavior:ScrollBehavior = new ScrollBehavior();
			scrollBehavior.horizontal = true;
			scrollBar2.behaviors.scroll = scrollBehavior;
			addChild(scrollBar2);
			
			listBox = new ListBox();
			listBox.x = 250;
			listBox.y = 30;
			listBox.skin = new GraphicSkin(new ListBoxGraphic());
			var listBehavior:ListBehavior = new ListBehavior();
			listBox.behaviors.list = listBehavior;
			addChild(listBox);
		}
	}
}

