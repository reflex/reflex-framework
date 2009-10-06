package reflex.containers
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.styles.StyleManager;
	
	import reflex.core.Component;

	public class Application extends Component
	{
		public function Application()
		{
			super();
			
			if (stage) {
				// the root of the application, already on stage when constructed
				contextMenu = new ContextMenu();
				contextMenu.hideBuiltInItems();
				contextMenu.customItems = [new ContextMenuItem("Reflex Component Preview 0.1", false, false)];
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.addEventListener(Event.RESIZE, onStageResize);
				onStageResize();
			}
		}
		
		protected function onStageResize(event:Event = null):void
		{
			measuredWidth = stage.stageWidth;
			measuredHeight = stage.stageHeight;
//			if (_skin) {
//				invalidate(_skin.draw);
//			}
			
			// RENDER does not get dispatched when flash is resizing, causing a
			// preceived performance issue because of lack of responsiveness.
			stage.dispatchEvent(new Event(Event.RENDER));
		}
	}
}