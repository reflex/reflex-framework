package
{
	import display.Containment;
	
	import flame.controls.ScrollBarGraphic;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import flash.utils.setInterval;
	
	import flight.binding.Bind;
	import flight.position.IPosition;
	
	import reflex.behavior.Behavior;
	import reflex.behavior.ButtonBehavior;
	import reflex.behavior.ScrollBehavior;
	import reflex.behavior.SelectableBehavior;
	import reflex.controls.Button;
	import reflex.controls.ScrollBar;
	import reflex.events.ButtonEvent;
	import reflex.events.RenderEvent;
	import reflex.layout.Block;
	import reflex.layout.Dock;
	import reflex.layout.Layout;
	import reflex.skin.GraphicSkin;
	import reflex.skin.MXMLButtonSkin;
	
	[SWF(widthPercent="100", heightPercent="100", frameRate="12")]
	public class reflex_dev extends Sprite
	{
		private var block:Block;
		private var containment:Containment;
		
		public function reflex_dev()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, onResize);
			ButtonEvent.initialize(stage);
//			stage.addEventListener(ButtonEvent.DRAG, onDrag);
//			stage.addEventListener(ButtonEvent.PRESS, onPress);
			
//			var button:Button = new Button();
//				button.label = "HI WORLD";
//			addChild(button);
//			block = new Block(button);
//			block.dock = Dock.RIGHT;
			
//			var buttonSkin:MXMLButtonSkin = new MXMLButtonSkin();
//				buttonSkin.target = button;
//				buttonSkin.button = button;
//			var buttonBehavior:ButtonBehavior = new ButtonBehavior(button);
//			var selectableBehavior:SelectableBehavior = new SelectableBehavior(button);
			
			containment = new Containment();
			
			// one
			var scrollbar:ScrollBar = new ScrollBar();
				scrollbar.skin = new GraphicSkin( getScrollGraphic() );
			var scrollBehavior:ScrollBehavior = new ScrollBehavior(scrollbar);
			scrollBehavior.position = containment.hPosition;
			addChild(scrollbar);
			
			block = new Block(scrollbar);
			block.dock = Dock.BOTTOM;
			
			// two
			scrollbar = new ScrollBar();
			scrollbar.skin = new GraphicSkin( getScrollGraphic() );
			scrollBehavior = new ScrollBehavior(scrollbar);
			scrollBehavior.position = containment.vPosition;
			addChild(scrollbar);
			
			block = new Block(scrollbar);
			block.dock = Dock.RIGHT;
			block.height = 100;
			block.rotation = -90;
			scrollbar.scaleX = -1;
			
			// three
			scrollbar = new ScrollBar();
			scrollbar.skin = new GraphicSkin( getScrollGraphic() );
			scrollBehavior = new ScrollBehavior(scrollbar);
			addChild(scrollbar);
			
			block = new Block(scrollbar);
			block.dock = Dock.FILL;
			
//			containment.target = scrollbar;
//			Bind.addBinding(containment, "hPosition.size", block, "width");
//			Bind.addBinding(containment, "vPosition.size", block, "height");
			
			block = new Block(this);
			block.padding = 20;
			block.padding.horizontal = block.padding.vertical = 10;
			
			onResize(null);
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
			containment.hPosition.space = stage.stageWidth/2;
			containment.vPosition.space = stage.stageHeight/2;
		}
		
		private var pressedWidth:Number = 0;
		private var pressedHeight:Number = 0;
		private function onPress(event:ButtonEvent):void
		{
			pressedWidth = containment.hPosition.value;
			pressedHeight = containment.vPosition.value;
		}
		
		private function onDrag(event:ButtonEvent):void
		{
			containment.hPosition.value = pressedWidth + event.deltaX;
			containment.vPosition.value = pressedHeight + event.deltaY;
			event.updateAfterEvent();
		}
		
	}
}

