package reflex.containers
{
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import reflex.binding.DataChange;
	
	
	//[Frame(factoryClass="reflex.tools.flashbuilder.ReflexApplicationLoader")]
	[SWF(widthPercent="100%", heightPercent="100%", frameRate="30")]
	
	/**
	 * @alpha
	 */
	public class Application extends Container
	{
		
		private var _backgroundColor:uint;
		
		// the compiler knows to look for this, so we don't really draw anything for it
		[Bindable(event="backgroundColorChange")]
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor(value:uint):void {
			DataChange.change(this, "backgroundColor", _backgroundColor, _backgroundColor = value);
		}
		
		public function Application()
		{
			super();
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
		}
	}
}