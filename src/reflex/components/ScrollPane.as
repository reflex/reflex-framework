package reflex.components
{
	import flash.display.InteractiveObject;
	
	import flight.binding.Bind;
	import flight.position.IPosition;
	
	import mx.core.Container;
	
	import reflex.behaviors.SlideBehavior;
	import reflex.display.ScrollContainer;
	import reflex.layout.Align;
	import reflex.layout.Block;
	import reflex.layout.LayoutWrapper;
	import reflex.measurement.resolveHeight;
	import reflex.skins.GraphicSkin;
	import reflex.skins.ScrollBarSkin;
	
	[DefaultProperty("container")]
	public class ScrollPane extends Component
	{
		[Bindable]
		public var horizontal:IPosition;
		
		[Bindable]
		public var vertical:IPosition;
		
		private var _container:InteractiveObject; [Bindable]
		public function get container():InteractiveObject { return _container; }
		public function set container(value:InteractiveObject):void {
			if(_container) { this.removeChild(_container); }
			_container = value;
			if(_container) { this.addChild(_container); }
		}
		
		public function ScrollPane()
		{
			Bind.addListener(this, onVerticalScroll, this, "vertical.value");
		}
		
		private function onVerticalScroll(value:Object):void {
			var height:Number = reflex.measurement.resolveHeight(this);
			var containerHeight:Number = reflex.measurement.resolveHeight(container);
			var potential:Number = containerHeight - height;
			if(vertical) {
				vertical.min = 0;
				vertical.max = containerHeight;
				container.y = potential * vertical.percent * -1;
			}
		}
		
		/*
		override protected function constructChildren():void
		{
			container = new ScrollContainer();
			//container.dock = Align.FILL;
			
			var graphic:ScrollPaneGraphic = new ScrollPaneGraphic();
			graphic.addChild(container);
			
			var block:Block;
			block = new Block(graphic.corner);
			block.scale = true;
			block.anchor.right = block.anchor.bottom = 0;
			
			var slideBehavior:SlideBehavior;
			var scrollBarSkin:ScrollBarSkin;
			
			slideBehavior = new SlideBehavior(graphic.hScroll);
			scrollBarSkin = new ScrollBarSkin(graphic.hScroll);
			scrollBarSkin.target = graphic.hScroll;
			hPosition = scrollBarSkin.position = slideBehavior.position = container.hPosition;
			scrollBarSkin.graphicBlock.dock = Align.BOTTOM;
			scrollBarSkin.graphicBlock.margin.right = graphic.corner.width;
			
			slideBehavior = new SlideBehavior(graphic.vScroll);
			scrollBarSkin = new ScrollBarSkin(graphic.vScroll);
			scrollBarSkin.target = graphic.vScroll;
			vPosition = scrollBarSkin.position = slideBehavior.position = container.vPosition;
			scrollBarSkin.graphicBlock.dock = Align.RIGHT;
			
			skin = new GraphicSkin(graphic);
		}
		*/
	}
}