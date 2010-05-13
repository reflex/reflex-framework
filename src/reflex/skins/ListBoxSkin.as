package reflex.skins
{
	import flight.binding.Bind;
	import flight.list.ArrayList;
	import flight.list.IList;
	import flight.position.IPosition;
	import flight.position.Position;
	
	import reflex.behaviors.SlideBehavior;
	import reflex.components.ScrollPaneGraphic;
	import reflex.display.Replicator;
	import reflex.display.ScrollContainer;
	import reflex.layout.Align;
	import reflex.layout.Block;

	public class ListBoxSkin extends GraphicSkin
	{
		[Bindable]
		public var position:IPosition = new Position();
		/*
		[Bindable]
		public var template:Class;
		*/
		[Bindable]
		public var dataProvider:IList = new ArrayList();
		
		public var container:ScrollContainer;
		
		private var replicator:Replicator;
		private var scrollPaneGraphic:ScrollPaneGraphic;
		
		public function ListBoxSkin(graphic:ScrollPaneGraphic = null)
		{
			graphic = scrollPaneGraphic = graphic || new ScrollPaneGraphic()
			super(scrollPaneGraphic);
			
			container = new ScrollContainer();
			//container.dock = Align.FILL;
			graphic.addChild(container);
			/*
			var block:Block;
			block = new Block(graphic.corner);
			block.scale = true;
			block.anchor.right = block.anchor.bottom = 0;
			*/
			var slideBehavior:SlideBehavior;
			var scrollBarSkin:ScrollBarSkin;
			/*
			slideBehavior = new SlideBehavior(graphic.hScroll);
			scrollBarSkin = new ScrollBarSkin(graphic.hScroll);
			scrollBarSkin.target = graphic.hScroll;
			scrollBarSkin.position = slideBehavior.position = container.hPosition;
			scrollBarSkin.graphicBlock.dock = Align.BOTTOM;
			scrollBarSkin.graphicBlock.margin.right = graphic.corner.width;
			
			slideBehavior = new SlideBehavior(graphic.vScroll);
			scrollBarSkin = new ScrollBarSkin(graphic.vScroll);
			scrollBarSkin.target = graphic.vScroll;
			position = scrollBarSkin.position = slideBehavior.position = container.vPosition;
			scrollBarSkin.graphicBlock.dock = Align.RIGHT;
			
			replicator = new Replicator(container);
			replicator.position = position;
			
			Bind.addBinding(replicator, "template", this, "template", true);
			Bind.addBinding(replicator, "dataProvider", this, "dataProvider", true);
			Bind.addBinding(this, "target.children", replicator, "children");
			Bind.addBinding(replicator, "coverageSize", container, "height");*/
		}
		
	}
}