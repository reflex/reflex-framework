package reflex.components
{
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	
	import reflex.layout.Layout;
	
	[SWF(widthPercent="100%", heightPercent="100%", frameRate="30")]
	public class Application extends Component
	{
		[Bindable]
		public var background:int = 0xFFFFFF;
		
		public function Application()
		{
			if (stage != null) {
				contextMenu = new ContextMenu();
				contextMenu.hideBuiltInItems();
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
				onStageResize(null);
			}
			
			addEventListener(Layout.LAYOUT, onLayout);
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
		
		private function onLayout(event:Event):void
		{
			draw();
		}
	}
}