package reflex.skins
{
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import reflex.layouts.BasicLayout;
	import reflex.text.Label;
	import reflex.text.TextFieldDisplay;

	public class GraphicListItemSkin extends GraphicSkin
	{
		
		public var labelDisplay:Label;
		
		public function GraphicListItemSkin()
		{
			super();
			labelDisplay = new Label();
			labelDisplay.color = 0xFFFFFF;
			labelDisplay.fontFamily = "sans-serif";
			labelDisplay.fontSize = 33;
			labelDisplay.style = "left: 10; right: 10; top: 5; bottom: 5;";
			layout = new BasicLayout();
			content = [labelDisplay];
			measured.width = 250;
			measured.height = 64;
		}
		
		override protected function render(currentState:String):void {
			if(graphics) {
				graphics.clear();
				switch(currentState) {
					case "up":
						renderUp();
						break;
					case "over":
						renderOver();
						break;
					case "down":
						renderDown();
						break;
					case "upAndSelected":
						renderDown();
						break;
					case "overAndSelected":
						renderDown();
						break;
					case "downAndSelected":
						renderDown();
						break;
					default:
						renderUp();
						break;
				}
			}
		}
		
		private function renderUp():void {
			graphics.beginFill(0xFCA527, 1);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
		}
		
		private function renderOver():void {
			graphics.beginFill(0xFCA527, 1);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
		}
		
		private function renderDown():void {
			graphics.beginFill(0x363636, 1);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
		}
		
	}
}