package
{
	import flame.controls.ScrollBarGraphic;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import reflex.events.ButtonEvent;
	import reflex.layout.Block;
	import reflex.layout.Dock;
	
	[SWF(widthPercent="100", heightPercent="100", frameRate="12")]
	public class reflex_dev extends Sprite
	{
		private var block:Block;
		private var block1:Block;
		private var block2:Block;
		
		public function reflex_dev()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
//			stage.addEventListener(Event.RESIZE, onResize);
			ButtonEvent.initialize(stage);
			stage.addEventListener(ButtonEvent.DRAG, onDrag);
			stage.addEventListener(ButtonEvent.PRESS, onPress);
			
			block1 = createScroll();
			block2 = createScroll();
			block1.dock = Dock.BOTTOM;
			block2.dock = Dock.LEFT;
			block2.bounds.minHeight = 50;
			block2.bounds.maxHeight = 300;
			
			block1 = createScroll();
			block2 = createScroll();
			block1.tile = Dock.LEFT;
			block2.tile = Dock.LEFT;
			
			block1 = createScroll();
			block2 = createScroll();
			block1.dock = Dock.FILL;
			block2.dock = Dock.RIGHT;
			
			block = new Block(this);
			block.padding = 30;
			block.padding.vertical = 20;
			block.padding.horizontal = 5;
			
			addChild( block1.target );
			addChild( block2.target );
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
			graphics.beginFill(0xEEEEEE);
			graphics.drawRect(0, 0, block.width, block.height);
			graphics.endFill();
			event.updateAfterEvent();
		}
		
		private var behaviors:Dictionary = new Dictionary();
		private function createScroll():Block
		{
			var scroll:ScrollBarGraphic = new ScrollBarGraphic();
			var block:Block = new Block(scroll);
			addChild(scroll);
			for (var i:int = 0; i < scroll.numChildren; i++) {
				block = new Block(scroll.getChildAt(i), true);
			}
			block = Block.blockIndex[scroll.bwdBtn];
			block.dock = Dock.LEFT;
			block.margin = 1;
			block = Block.blockIndex[scroll.fwdBtn];
			block.dock = Dock.RIGHT;
			block.margin = 1;
			block = Block.blockIndex[scroll.track];
			block.dock = Dock.FILL;
			block = Block.blockIndex[scroll.thumb];
			block.dock = Dock.FILL;
			block.margin = 2;
			block = Block.blockIndex[scroll.background];
			block.dock = Dock.FILL;
			
			return Block.blockIndex[scroll];
		}
		
	}
}

