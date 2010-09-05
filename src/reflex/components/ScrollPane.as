package reflex.components
{
	
	import flash.display.InteractiveObject;
	
	import reflex.binding.Bind;
	import reflex.data.IPosition;
	import reflex.data.PositionUtil;
	import reflex.events.PropertyEvent;
	import reflex.measurement.resolveHeight;
	
	[DefaultProperty("container")]
	public class ScrollPane extends Component
	{
		
		private var _horizontal:IPosition;
		private var _vertical:IPosition;
		private var _container:InteractiveObject; 
		
		[Bindable(event="horizontalChange")]
		public function get horizontal():IPosition { return _horizontal; }
		public function set horizontal(value:IPosition):void {
			if(_horizontal == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "horizontal", _horizontal, _horizontal = value);
		}
		
		[Bindable(event="verticalChange")]
		public function get vertical():IPosition { return _vertical; }
		public function set vertical(value:IPosition):void {
			if(_vertical == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "vertical", _vertical, _vertical = value);
		}
		
		[Bindable(event="containerChange")]
		public function get container():InteractiveObject { return _container; }
		public function set container(value:InteractiveObject):void {
			if(_container) { this.removeChild(_container); }
			var oldContainer:InteractiveObject = _container;
			_container = value;
			if(_container) { this.addChild(_container); }
			PropertyEvent.dispatchChange(this, "container", oldContainer, _container);
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
				container.y = potential * PositionUtil.getPercent(vertical) * -1;
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