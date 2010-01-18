package
{
	import flame.controls.ScrollBarGraphic;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import reflex.behavior.Behavior;
	import reflex.behavior.ScrollBehavior;
	import reflex.controls.ScrollBar;
	import reflex.events.ButtonEvent;
	import reflex.layout.Block;
	import reflex.layout.Dock;
	import reflex.layout.Layout;
	import reflex.skin.GraphicSkin;
	
	[SWF(widthPercent="100", heightPercent="100", frameRate="12")]
	public class reflex_dev extends Sprite
	{
		private var block:Block;
		
		public function reflex_dev()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
//			stage.addEventListener(Event.RESIZE, onResize);
//			ButtonEvent.initialize(stage);
//			stage.addEventListener(ButtonEvent.DRAG, onDrag);
//			stage.addEventListener(ButtonEvent.PRESS, onPress);
			
			var scrollbar:ScrollBar = new ScrollBar();
				scrollbar.skin = new GraphicSkin( getScrollGraphic() );
			var scrollBehavior:ScrollBehavior = new ScrollBehavior(scrollbar);
			block = new Block(scrollbar);
			addChild(scrollbar);
			block.width = 400;
			block.height = 100;
		}
		
		private function getScrollGraphic():ScrollBarGraphic
		{
			var scroll:ScrollBarGraphic = new ScrollBarGraphic();
			var block:Block = new Block(scroll);
			block.anchor = 0;
			block = new Block(scroll.background);
			block.scale = true;
			block.dock = Dock.FILL;
			block = new Block(scroll.bwdBtn);
			block.scale = true;
			block.dock = Dock.LEFT;
			block.margin = 1;
			block.margin.right = 0;
			block = new Block(scroll.fwdBtn);
			block.scale = true;
			block.dock = Dock.RIGHT;
			block.margin = 1;
			block.margin.left = 0;
			block = new Block(scroll.track);
			block.scale = true;
			block.dock = Dock.FILL;
			block = new Block(scroll.thumb);
			block.scale = true;
			block.anchor.top = block.anchor.bottom = 3;
			
			return scroll;
		}
		
		private function onResize(event:Event):void
		{
			block.width = stage.stageWidth;
			block.height = stage.stageHeight;
		}
		
		private var pressedWidth:Number = 0;
		private var pressedHeight:Number = 0;
		private function onPress(event:ButtonEvent):void
		{
			pressedWidth = block.width;
			pressedHeight = block.height;
		}
		
		private function onDrag(event:ButtonEvent):void
		{
			block.width = pressedWidth + event.deltaX;
			block.height = pressedHeight + event.deltaY; 
			graphics.clear();
			graphics.lineStyle(0, 0xAABBDD);
			graphics.beginFill(0xDDE6EE);
			graphics.drawRect(0, 0, block.width, block.height);
			graphics.endFill();
			event.updateAfterEvent();
		}
		
	}
}

