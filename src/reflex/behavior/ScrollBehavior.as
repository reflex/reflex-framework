package reflex.behavior
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import flight.binding.Bind;
	import flight.position.IPosition;
	import flight.position.Position;
	
	import mx.controls.Button;
	
	import reflex.core.ISkin;
	import reflex.core.ISkinnable;
	import reflex.events.ButtonEvent;
	
	[Bindable]
	public class ScrollBehavior extends Behavior
	{
		public var fwdBtn:InteractiveObject;
		public var bwdBtn:InteractiveObject;
		public var track:InteractiveObject;
		public var thumb:InteractiveObject;
		
		public var horizontal:Boolean = false;
		public var position:IPosition = new Position();
		
		private var forwardPress:Boolean;
		
		public function ScrollBehavior()
		{
			position = new Position();
			position.max = 100;
			position.stepSize = 5;
			position.skipSize = 20;
		}
		
		override public function set target(value:InteractiveObject):void
		{
			super.target = value;
			
			if (target == null) {
				return;
			}
			
			fwdBtn = getSkinPart('fwdBtn');
			bwdBtn = getSkinPart('bwdBtn');
			track = getSkinPart('track');
			thumb = getSkinPart('thumb');
			
			if (track.width > track.height) {
				horizontal = true;
			}
			
			ButtonEvent.initialize(fwdBtn);
			ButtonEvent.initialize(bwdBtn);
			ButtonEvent.initialize(track);
			ButtonEvent.initialize(thumb);
			Bind.addListener(onPosition, this, "position.position");	// TODO: replace with metadata [BindListener]
		}
		
		[BindListener(target="position.position")]						// TODO: implement in favor of Bind.addListener...
		private function onPosition(event:Event):void
		{
			trace(position.position);
			
			if (thumb != null && track != null) {
				var p:Point = new Point();
				if (horizontal) {
					p.x = (track.width - thumb.width) * position.percent;
					p = thumb.parent.globalToLocal( track.localToGlobal(p) );
					thumb.x = p.x;
				} else {
					p.y = (track.height - thumb.height) * position.percent;
					p = thumb.parent.globalToLocal( track.localToGlobal(p) );
					thumb.y = p.y;
				}
			}
		}
		
		[EventListener(type="press", target="fwdBtn")]
		[EventListener(type="hold", target="fwdBtn")]
		public function onFwdPress(event:ButtonEvent):void
		{
			position.forward();
			event.updateAfterEvent();
		}
		
		[EventListener(type="press", target="bwdBtn")]
		[EventListener(type="hold", target="bwdBtn")]
		public function onBwdPress(event:ButtonEvent):void
		{
			position.backward();
			event.updateAfterEvent();
		}
		
		[EventListener(type="press", target="track")]
		public function onTrackPress(event:ButtonEvent):void
		{
			var size:Number = horizontal ? track.width : track.height;
			forwardPress = (horizontal ? track.mouseX : track.mouseY) > (size * position.percent);
			
			if (forwardPress) {
				position.skipForward();
			} else {
				position.skipBackward();
			}
			event.updateAfterEvent();
		}
		
		[EventListener(type="hold", target="track")]
		public function onTrackHold(event:ButtonEvent):void
		{
			var size:Number = horizontal ? track.width : track.height;
			var forwardHold:Boolean = (horizontal ? track.mouseX : track.mouseY) > (size * position.percent);
			
			if (forwardPress != forwardHold) {
				return;
			}
			
			if (forwardPress) {
				position.skipForward();
			} else {
				position.skipBackward();
			}
			event.updateAfterEvent();
		}
		
		private var dragPosition:Number;
		private var dragPoint:Number;
		private var dragSize:Number;
		[EventListener(type="press", target="thumb")]
		public function onThumbPress(event:ButtonEvent):void
		{
			dragSize = horizontal ? track.width - thumb.width : track.height - thumb.height;
			dragPoint = horizontal ? track.mouseX : track.mouseY;
			dragPosition = position.percent;
			event.updateAfterEvent();
		}
		
		[EventListener(type="drag", target="thumb")]
		public function onThumbDrag(event:ButtonEvent):void
		{
			var mousePoint:Number = horizontal ? track.mouseX : track.mouseY;
			var delta:Number = (mousePoint - dragPoint) / dragSize;
			position.percent = dragPosition + delta;
			event.updateAfterEvent();
		}
		
	}
}