package reflex.skins
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import reflex.layouts.BasicLayout;
	import reflex.text.Label;
	import reflex.text.TextFieldDisplay;

	public class GraphicRadioButtonSkin extends GraphicSkin
	{
		
		public var labelDisplay:Label;
		
		public function GraphicRadioButtonSkin()
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
			}
		}
		
		private function renderUp():void {
			graphics.beginFill(0xFFFFFF, 1);
			graphics.drawCircle(15, unscaledHeight/2, 15);
			graphics.endFill();
		}
		
		private function renderUpAndSelected():void {
			graphics.beginFill(0xFFFFFF, 1);
			graphics.drawCircle(15, unscaledHeight/2, 15);
			graphics.endFill();
			graphics.beginFill(0x1E1E1E, 1);
			graphics.drawCircle(15, unscaledHeight/2, 8);
			graphics.endFill();
		}
		
	}
}