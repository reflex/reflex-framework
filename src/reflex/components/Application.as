package reflex.components
{
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	
	import reflex.display.Container;
	import reflex.events.InvalidationEvent;
	import reflex.layout.LayoutWrapper;
	
	//[Frame(factoryClass="reflex.tools.flashbuilder.ReflexApplicationLoader")]
	[SWF(widthPercent="100%", heightPercent="100%", frameRate="30")]
	
	/**
	 * @alpha
	 */
	public class Application extends Container
	{
		
		public function Application()
		{
			if (stage == null) {
				return;
			}
			
			//contextMenu = new ContextMenu();
			//contextMenu.hideBuiltInItems();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			
			onStageResize(null);
		}
		
		private function onStageResize(event:Event):void
		{
			width = stage.stageWidth;
			height = stage.stageHeight;
			//setSize(stage.stageWidth, stage.stageHeight);
			/*var perspective:PerspectiveProjection = new PerspectiveProjection();
			perspective.projectionCenter = new Point(stage.stageWidth/2, stage.stageHeight/2);
			stage.transform.perspectiveProjection = perspective;*/
			//InvalidationEvent.invalidate(this, MEASURE);
			//InvalidationEvent.invalidate(this, LAYOUT);
		}
	}
}