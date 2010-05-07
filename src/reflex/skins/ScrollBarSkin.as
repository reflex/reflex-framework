package reflex.skins
{
	import flash.events.Event;
	
	import flight.binding.Bind;
	import flight.position.IPosition;
	
	import legato.components.ScrollBarGraphic;
	
	import reflex.components.Button;
	import reflex.layout.Align;
	import reflex.layout.Block;
	import reflex.layout.LayoutWrapper;

	public class ScrollBarSkin extends GraphicSkin
	{
		// skinParts with StepBehavior
		public var fwdBtn:Button;
		public var bwdBtn:Button;
		
		// skinParts with SlideBehavior
		public var track:Button;
		public var thumb:Button;
		
		[Bindable]
		public var position:IPosition;
		
		private var scrollBarGraphic:ScrollBarGraphic;
		
		public function ScrollBarSkin(graphic:ScrollBarGraphic = null)
		{
			graphic = scrollBarGraphic = graphic || new ScrollBarGraphic()
			super(scrollBarGraphic);
			
			var block:Block;
			block = new Block(graphic.background);
			block.scale = true;
			block.dock = Align.FILL;
			block = new Block(graphic.bwdBtn);
			block.scale = true;
			block.dock = Align.LEFT;
			block = new Block(graphic.fwdBtn);
			block.scale = true;
			block.dock = Align.RIGHT;
			block = new Block(graphic.track);
			block.scale = true;
			block.dock = Align.FILL;
			block = new Block(graphic.thumb);
			block.scale = true;
			block.anchor.top = block.anchor.bottom = 0;
			block.bounds.minWidth = block.bounds.minHeight = 10;
			
			Bind.addListener(this, onSizeChange, this, "position.size");
			Bind.addListener(this, onSizeChange, this, "position.space");
		}
		
		private function onSizeChange(size:Number):void
		{
			if (position == null) {
				return;
			}
			
			if (position.filled) {
				scrollBarGraphic.thumb.visible = false;
				return;
			}
			
			scrollBarGraphic.thumb.visible = true;
			var block:Block = LayoutWrapper.getLayout(scrollBarGraphic.thumb) as Block;
			block.width = scrollBarGraphic.track.width/position.size * position.space;
		}
		
	}
}