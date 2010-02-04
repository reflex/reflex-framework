package reflex.component
{
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import flight.binding.Bind;
	
	import reflex.layout.Layout;
	
	public class Application extends Component
	{
		[Bindable]
		public var background:int = 0xFFFFFF;
		
		public function Application()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			// TODO: "bitmaps are always smoothed" vs "bitmaps are smoothed if the movie is static"
			// ... is this a noticable quality improvement?
			stage.quality = StageQuality.BEST;
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			
			addEventListener(Layout.LAYOUT, redraw);
		}
		
		protected function draw():void
		{
			graphics.clear();
			graphics.beginFill(background);
			graphics.drawRect(0, 0, displayWidth, displayHeight);
			graphics.endFill();
		}
		
		private function onStageResize(event:Event):void
		{
			block.width = stage.stageWidth;
			block.height = stage.stageHeight;
		}
		
		private function redraw(event:Event):void
		{
			draw();
		}
	}
}