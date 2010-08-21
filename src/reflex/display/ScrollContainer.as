package reflex.display
{
	import flash.events.Event;
	
	import flight.binding.Bind;
	import flight.events.PropertyEvent;
	import flight.position.IPosition;
	
	public class ScrollContainer extends Container
	{
		
		private _horizontal:IPosition;
		private _vertical:IPosition;
		
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
		
		/*
		override public function set background(value:Number):void
		{
			super.background = value;
			opaqueBackground = background;
			cacheAsBitmap = !isNaN(background);
		}
		
		override public function get width():Number
		{
			return block.width;
		}
		override public function set width(value:Number):void
		{
			block.width = value;
		}
		
		override public function get height():Number
		{
			return block.height;
		}
		override public function set height(value:Number):void
		{
			block.height = value;
		}
		
		protected function initLayout():void
		{
			var scrollBlock:ScrollBlock = new ScrollBlock();
			hPosition = scrollBlock.hPosition;
			vPosition = scrollBlock.vPosition;
			Bind.addBinding(scrollBlock, "hPosition", this, "hPosition");
			Bind.addBinding(scrollBlock, "vPosition", this, "vPosition");
			Bind.addBinding(scrollBlock, "freeform", this, "freeform", true);
			scrollBlock.addEventListener("xChange", forwardEvent);
			scrollBlock.addEventListener("yChange", forwardEvent);
			scrollBlock.addEventListener("displayWidthChange", forwardEvent);
			scrollBlock.addEventListener("displayWidthChange", onWidthChange);
			scrollBlock.addEventListener("displayHeightChange", forwardEvent);
			scrollBlock.addEventListener("displayHeightChange", onHeightChange);
			scrollBlock.addEventListener("snapToPixelChange", forwardEvent);
			scrollBlock.addEventListener("layoutChange", forwardEvent);
			scrollBlock.addEventListener("boundsChange", forwardEvent);
			scrollBlock.addEventListener("marginChange", forwardEvent);
			scrollBlock.addEventListener("paddingChange", forwardEvent);
			scrollBlock.addEventListener("dockChange", forwardEvent);
			scrollBlock.addEventListener("alignChange", forwardEvent);
			
			//block = scrollBlock;
		}
		
		private function forwardEvent(event:Event):void
		{
			dispatchEvent(event);
		}
		
		private function onWidthChange(event:Event):void
		{
			dispatchEvent( new Event("widthChange") );
		}
		
		private function onHeightChange(event:Event):void
		{
			dispatchEvent( new Event("heightChange") );
		}
		*/
	}
}