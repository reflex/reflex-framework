package
{
	import flame.controls.ScrollBarGraphic;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import flight.binding.Bind;
	
	import reflex.behaviors.ScrollBehavior;
	import reflex.component.Application;
	import reflex.controls.ScrollBar;
	import reflex.display.Containment;
	import reflex.events.ButtonEvent;
	import reflex.layout.Block;
	import reflex.layout.Dock;
	import reflex.skins.GraphicSkin;
	
	[SWF(widthPercent="100%", heightPercent="100%", frameRate="12")]
	public class reflex_dev extends Application
	{
		private var containment:Containment;
		
		public function reflex_dev()
		{
			background = 0xAABBCC;
			
			containment = new Containment();
			
			// one
			var scrollbar:ScrollBar = new ScrollBar();
				scrollbar.skin = new GraphicSkin( getScrollGraphic() );
			var scrollBehavior:ScrollBehavior = new ScrollBehavior(scrollbar);
			scrollBehavior.position = containment.hPosition;
			addChild(scrollbar);
			
			scrollbar.dock = Dock.BOTTOM;
			
			// two
			scrollbar = new ScrollBar();
			scrollbar.skin = new GraphicSkin( getScrollGraphic() );
			scrollBehavior = new ScrollBehavior(scrollbar);
			scrollBehavior.position = containment.vPosition;
			addChild(scrollbar);
			
			scrollbar.dock = Dock.RIGHT;
			scrollbar.height = 50;
			scrollbar.rotation = -90;
			scrollbar.scaleX = -1;
			
			// three
			scrollbar = new ScrollBar();
			scrollbar.skin = new GraphicSkin( getScrollGraphic() );
			scrollBehavior = new ScrollBehavior(scrollbar);
			addChild(scrollbar);
			
			scrollbar.dock = Dock.FILL;
			
			containment.target = scrollbar;
			containment.hPosition.space = 400;
			containment.vPosition.space = 300;
			Bind.addBinding(containment, "hPosition.size", scrollbar, "width");
			Bind.addBinding(containment, "vPosition.size", scrollbar, "height");
			
			padding = 20;
			padding.horizontal = padding.vertical = 10;
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
		
		private var pressedWidth:Number = 0;
		private var pressedHeight:Number = 0;
		private function onPress(event:ButtonEvent):void
		{
			pressedWidth = containment.hPosition.space;
			pressedHeight = containment.vPosition.space;
		}
		
		private function onDrag(event:ButtonEvent):void
		{
			containment.hPosition.space = pressedWidth + event.deltaX;
			containment.vPosition.space = pressedHeight + event.deltaY;
			event.updateAfterEvent();
		}
		
	}
}

