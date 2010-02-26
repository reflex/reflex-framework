package reflex.components
{
	import flight.binding.Bind;
	import flight.position.IPosition;
	
	import mx.core.Container;
	
	import reflex.behaviors.ScrollBehavior;
	import reflex.display.ScrollContainer;
	import reflex.layout.Align;
	import reflex.layout.Block;
	import reflex.layout.Layout;
	import reflex.skins.GraphicSkin;
	import reflex.skins.ScrollBarSkin;

	public class ScrollPane extends Component
	{
		[Bindable]
		public var hPosition:IPosition;
		
		[Bindable]
		public var vPosition:IPosition;
		
		public var container:ScrollContainer;
		
		public function ScrollPane()
		{
		}
		
		override protected function constructChildren():void
		{
			container = new ScrollContainer();
			container.dock = Align.FILL;
			
			var graphic:ScrollPaneGraphic = new ScrollPaneGraphic();
			graphic.addChild(container);
			
			var block:Block;
			block = new Block(graphic.corner);
			block.scale = true;
			block.anchor.right = block.anchor.bottom = 0;
			
			var scrollBehavior:ScrollBehavior;
			var scrollBarSkin:ScrollBarSkin;
			
			scrollBehavior = new ScrollBehavior(graphic.hScroll);
			scrollBarSkin = new ScrollBarSkin(graphic.hScroll);
			scrollBarSkin.target = graphic.hScroll;
			hPosition = scrollBarSkin.position = scrollBehavior.position = container.hPosition;
			scrollBarSkin.graphicBlock.dock = Align.BOTTOM;
			scrollBarSkin.graphicBlock.margin.right = graphic.corner.width;
			
			scrollBehavior = new ScrollBehavior(graphic.vScroll);
			scrollBarSkin = new ScrollBarSkin(graphic.vScroll);
			scrollBarSkin.target = graphic.vScroll;
			vPosition = scrollBarSkin.position = scrollBehavior.position = container.vPosition;
			scrollBarSkin.graphicBlock.dock = Align.RIGHT;
			
			skin = new GraphicSkin(graphic);
		}
		
	}
}