package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	import flight.binding.Bind;
	import flight.events.PropertyEvent;
	import flight.position.IPosition;
	import flight.position.Position;
	
	public class ScrollBlock extends Block
	{
		[Bindable]
		public var hPosition:IPosition = new Position();		// TODO: implement lazy instantiation of Position
		
		[Bindable]
		public var vPosition:IPosition = new Position();
		
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		public function ScrollBlock(target:DisplayObject=null, scale:Boolean=false)
		{
			Bind.addBinding(this, "hPosition.space", this, "width", true);
			Bind.addBinding(this, "vPosition.space", this, "height", true);
			Bind.addBinding(this, "hPosition.size", this, "displayWidth");
			Bind.addBinding(this, "vPosition.size", this, "displayHeight");
			
			Bind.addListener(this, onPositionChange, this, "hPosition.value");
			Bind.addListener(this, onPositionChange, this, "vPosition.value");
			Bind.addListener(this, onPositionChange, this, "hPosition.space");
			Bind.addListener(this, onPositionChange, this, "vPosition.space");
			Bind.addListener(this, onPositionChange, this, "hPosition.filled");
			Bind.addListener(this, onPositionChange, this, "vPosition.filled");
			
			hPosition.stepSize = vPosition.stepSize = 10;
			hPosition.skipSize = vPosition.skipSize = 100;
			
			super(target, scale);
		}
		
		override public function set target(value:DisplayObject):void
		{
			if (target == value) {
				return;
			}
			
			if (target != null) {
				target.scrollRect = null;
			}
			
			super.target = value;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			if (_width == value) {
				return;
			}
			
			super.width = value;
			_width = PropertyEvent.change(this, "width", _width, value);
			PropertyEvent.dispatch(this);
		}
		
		override public function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			if (_height == value) {
				return;
			}
			
			super.height = value;
			_height = PropertyEvent.change(this, "height", _height, value);
			PropertyEvent.dispatch(this);
		}
		
		override public function get blockBounds():Bounds
		{
			return bounds;
		}
		
		override public function measure():void
		{
			var container:DisplayObjectContainer = target as DisplayObjectContainer;
			if (container == null) {
				return;
			}
			
			if (algorithm != null) {
				algorithm.measure(container);
			}
			
			var measurement:Bounds = new Bounds();
			
			for (var i:int = 0; i < container.numChildren; i++) {
				var display:DisplayObject = container.getChildAt(i);
				var child:Block = getLayout(display) as Block;
				if (child == null || child.freeform) {
					continue;
				}
				
				measurement.minWidth = measurement.constrainWidth(
					display.x + child.width + padding.right + child.margin.right);
				
				measurement.minHeight = measurement.constrainHeight(
					display.y + child.height + padding.bottom + child.margin.bottom);
			}
			
			updateMeasurement(measurement);
		}
		
		private function onPositionChange(percent:Number):void
		{
			if (target == null) {
				return;
			}
			
			if (hPosition.filled && vPosition.filled) {
				target.scrollRect = null;
			} else {
				var rect:Rectangle = target.scrollRect;
				if (rect == null) {
					rect = new Rectangle(hPosition.value, vPosition.value, hPosition.space, vPosition.space);
				} else {
					rect.x = hPosition.value;
					rect.y = vPosition.value;
					rect.width = hPosition.space;
					rect.height = vPosition.space;
				}
				target.scrollRect = rect;
			}
		}
		
	}
}