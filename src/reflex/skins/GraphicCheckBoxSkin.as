package reflex.skins
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import reflex.layouts.BasicLayout;
	import reflex.text.Label;
	import reflex.text.TextFieldDisplay;

	public class GraphicCheckBoxSkin extends GraphicSkin
	{
		
		public var labelDisplay:Label;
		
		public function GraphicCheckBoxSkin()
		{
			super();
			labelDisplay = new Label();
			labelDisplay.color = 0xFFFFFF;
			labelDisplay.fontFamily = "sans-serif";
			labelDisplay.fontSize = 24;
			labelDisplay.style = "left: 37; right: 0; top: 0; bottom: 0;";
			layout = new BasicLayout();
			content = [labelDisplay];
		}
		
		override protected function render(currentState:String):void {
			graphics.clear();
			graphics.lineStyle(0,0,0);
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
			
			switch(currentState) {
				case "up":
					renderUp();
					break;
				case "over":
					renderUp();
					break;
				case "down":
					renderUp();
					break;
				case "upAndSelected":
					renderUpAndSelected();
					break;
				case "overAndSelected":
					renderUpAndSelected();
					break;
				case "downAndSelected":
					renderUpAndSelected();
					break;
				default:
					renderUp();
					break;
			}
		}
		
		private function renderUp():void {
			graphics.beginFill(0xFFFFFF, 1);
			graphics.drawRect(0, unscaledHeight/2-15, 30, 30);
			graphics.endFill();
		}
		
		private function renderUpAndSelected():void {
			graphics.beginFill(0xFFFFFF, 1);
			graphics.drawRect(0, unscaledHeight/2-15, 30, 30);
			graphics.endFill();
			graphics.beginFill(0x1E1E1E, 1);
			graphics.drawRect(7, unscaledHeight/2-8, 16, 16);
			graphics.endFill();
		}
		
	}
}