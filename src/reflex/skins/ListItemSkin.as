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

	public class ListItemSkin extends GraphicSkin
	{
		
		private var _labelDisplay:Label;
		
		[Bindable(event="labelDisplayChange")]
		public function get labelDisplay():Label { return _labelDisplay; }
		public function set labelDisplay(value:Label):void {
			notify("labelDisplay", _labelDisplay, _labelDisplay = value);
		}
		
		public function ListItemSkin()
		{
			super();
			labelDisplay = new Label();
			labelDisplay.color = 0xFFFFFF;
			labelDisplay.fontFamily = "sans-serif";
			labelDisplay.fontSize = 33;
			labelDisplay.style = "left: 10; right: 10; top: 5; bottom: 5;";
			layout = new BasicLayout();
			content = [labelDisplay];
			_measuredWidth = 250;
			_measuredHeight = 64;
		}
		
		override protected function render(currentState:String):void {
			if(graphics) {
				graphics.clear();
				if(unscaledWidth > 0 && unscaledHeight > 0) {
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