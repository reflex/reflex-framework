package
{
	import flame.controls.ScrollBarGraphic;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import reflex.layout.Block;
	
	[SWF(widthPercent="100", heightPercent="100", frameRate="15")]
	public class reflex_dev extends Sprite
	{
		private var block:Block;
		private var block1:Block;
		private var block2:Block;
		
		public function reflex_dev()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, onResize);
			
			block = new Block(this);
			block1 = createScroll();
			block2 = createScroll();
			addChild( block1.target );
			addChild( block2.target );
		}
		
		private function onResize(event:Event):void
		{
			block.width = stage.stageWidth;
			block.height = stage.stageHeight;
		}
		
		private function createScroll():Block
		{
			var scroll:ScrollBarGraphic = new ScrollBarGraphic();
				scroll;
				scroll.fwdBtn;
				scroll.bwdBtn;
				scroll.track;
				scroll.thumb;
			addChild(scroll);
			
			var block:Block;
			block = new Block(scroll.fwdBtn);
			block = new Block(scroll.bwdBtn);
			block = new Block(scroll.track);
			block = new Block(scroll.thumb);
			block = new Block(scroll);
			
			return block;
		}
		
		
	}
}

