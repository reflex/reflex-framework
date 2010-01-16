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
	import reflex.layout.Layout;
	
	[SWF(widthPercent="100", heightPercent="100", frameRate="12")]
	public class reflex_dev extends Sprite
	{
		private var block:Block;
		
		public function reflex_dev()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
//			stage.addEventListener(Event.RESIZE, onResize);
			ButtonEvent.initialize(stage);
			stage.addEventListener(ButtonEvent.DRAG, onDrag);
			stage.addEventListener(ButtonEvent.PRESS, onPress);
			
			block = createComplex();
			block.dock = Dock.BOTTOM;
			addChild(block.target);
			
			block = createComplex();
			block.dock = Dock.LEFT;
			addChild(block.target);
			
			block = createComplex();
			block.dock = Dock.TOP;
			addChild(block.target);
			
			block = createComplex();
			block.dock = Dock.RIGHT;
			addChild(block.target);
			
			block = createComplex();
			block.dock = Dock.FILL;
			addChild(block.target);
			
			block = new Block(this);
			block.padding = 30;
			block.padding.vertical = 8;
			block.padding.horizontal = 8;
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
		
		private function createComplex():Block
		{
			var sprite:Sprite = new Sprite();
			var block:Block = new Block(sprite);
				block.padding = 4;
				block.padding.horizontal = block.padding.vertical = 2;
			
			var block1:Block;
			var block2:Block;
			block1 = createScroll();
			block2 = createScroll();
			block1.dock = Dock.BOTTOM;
			block2.dock = Dock.LEFT;
			sprite.addChild( block1.target );
			sprite.addChild( block2.target );
			
			block1 = createScroll();
			block2 = createScroll();
			block1.dock = Dock.TOP;
			block2.dock = Dock.RIGHT;
			sprite.addChild( block1.target );
			sprite.addChild( block2.target );
			
			block1 = createScroll();
			block2 = createScroll();
			block1.dock = Dock.TOP;
			block2.tile = Dock.TOP;
			block2.dock = Dock.RIGHT;
			sprite.addChild( block1.target );
			sprite.addChild( block2.target );
			
			block1 = createScroll();
			block2 = createScroll();
			block1.tile = Dock.TOP;
			block1.dock = Dock.RIGHT;
			block2.tile = Dock.TOP;
			block2.dock = Dock.RIGHT;
			sprite.addChild( block1.target );
			sprite.addChild( block2.target );
			
			block1 = createScroll();
			block2 = createScroll();
			block1.dock = Dock.RIGHT;
			block2.dock = Dock.FILL;
			sprite.addChild( block1.target );
			sprite.addChild( block2.target );
			
			return block;
		}
		
		private function createScroll():Block
		{
			var scroll:ScrollBarGraphic = new ScrollBarGraphic();
			var block:Block = new Block(scroll);
			block.width = 10;
			block.height = 10;
			addChild(scroll);
			for (var i:int = 0; i < scroll.numChildren; i++) {
				block = new Block(scroll.getChildAt(i), true);
			}
			block = Layout.getLayout(scroll.bwdBtn) as Block;
			block.dock = Dock.LEFT;
			block.margin = 1;
			block.width = 5;
			block = Layout.getLayout(scroll.fwdBtn) as Block;
			block.dock = Dock.RIGHT;
			block.margin = 1;
			block.width = 5;
			block = Layout.getLayout(scroll.track) as Block;
			block.dock = Dock.FILL;
			block = Layout.getLayout(scroll.thumb) as Block;
			block.anchor.top = block.anchor.bottom = 2;
			block.anchor.horizontal = .5;
			block.width = 5;
			block = Layout.getLayout(scroll.background) as Block;
			block.dock = Dock.FILL;
			
			return Layout.getLayout(scroll) as Block;
		}
		
	}
}

