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
		public function Application()
		{
			if (stage == null) {
				return;
			}
			
			contextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			onStageResize(null);
		}
		
		private function onStageResize(event:Event):void
		{
			block.width = stage.stageWidth;
			block.height = stage.stageHeight;
		}
	}
}