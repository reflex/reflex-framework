package reflex.components
{
	import flight.position.IPosition;
	
	import reflex.behaviors.ScrollBehavior;
	import reflex.layout.Align;
	import reflex.layout.Block;
	import reflex.skins.GraphicSkin;
	
	public class ScrollBar extends Component
	{
		[Bindable]
		public var position:IPosition;
		
		public function ScrollBar()
		{
			var graphic:ScrollBarGraphic = new ScrollBarGraphic();
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
			
			skin = new GraphicSkin(graphic);
			new ScrollBehavior(this);
		}
	}
}