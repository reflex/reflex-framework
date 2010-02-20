package reflex.components
{
	import flash.events.Event;
	
	import flight.binding.Bind;
	import flight.position.IPosition;
	
	import reflex.behaviors.ScrollBehavior;
	import reflex.layout.Align;
	import reflex.layout.Block;
	import reflex.layout.Layout;
	import reflex.skins.GraphicSkin;
	
	public class ScrollBar extends Component
	{
		[Bindable]
		public var position:IPosition;
		
		public function ScrollBar()
		{
			graphic = new ScrollBarGraphic();
			var block:Block;
			block = new Block(graphic.background);
			block.scale = true;
			block.dock = Align.FILL;
			block = new Block(graphic.bwdBtn);
			block.scale = true;
			block.dock = Align.LEFT;
			block.margin = 1;
			block.margin.right = 0;
			block = new Block(graphic.fwdBtn);
			block.scale = true;
			block.dock = Align.RIGHT;
			block.margin = 1;
			block.margin.left = 0;
			block = new Block(graphic.track);
			block.scale = true;
			block.dock = Align.FILL;
			block = new Block(graphic.thumb);
			block.scale = true;
			block.anchor.top = block.anchor.bottom = 3;
			block.bounds.minWidth = 10;
			
			skin = new GraphicSkin(graphic);
			new ScrollBehavior(this);
			Bind.addListener(onSizeChange, this, "position.size");
			Bind.addListener(onSizeChange, this, "position.space");
		}
		
		private var graphic:ScrollBarGraphic;
		private function onSizeChange(event:Event):void
		{
			var block:Block = Layout.getLayout(graphic.thumb) as Block;
			block.width = graphic.track.width/position.size * position.space;
		}
		
	}
}