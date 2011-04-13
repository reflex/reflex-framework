package reflex.skins
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import reflex.layouts.BasicLayout;
	import reflex.text.Label;
	import reflex.text.TextFieldDisplay;

	public class GraphicHSliderSkin extends GraphicSkin
	{
		
		public var thumb:Sprite;
		public var track:Sprite;
		
		public function GraphicHSliderSkin()
		{
			super();
			unscaledHeight = 14;
			track = new Sprite();
			renderTrack(track.graphics);
			thumb = new Sprite();
			renderThumb(thumb.graphics);
			content = [track, thumb];
			measured.width = 170;
			measured.height = 14;
		}
		
		override protected function render(currentState:String):void {
			renderTrack(track.graphics);
			renderThumb(thumb.graphics);
		}
		
		private function renderThumb(g:Graphics):void {
			g.clear();
			g.beginFill(0xFFFFFF, 1);
			g.drawRect(0, 0, 14, unscaledHeight);
			g.endFill();
		}
		
		private function renderTrack(g:Graphics):void {
			g.clear();
			g.beginFill(0x363636, 1);
			g.drawRect(0, 0, unscaledWidth, unscaledHeight);
			g.endFill();
		}
		
	}
}