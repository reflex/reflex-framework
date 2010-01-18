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
		private var dragPosition:Number;
		private var dragPoint:Number;
		
		public function ScrollBehavior(target:InteractiveObject = null)
		{
			position = new Position();
			position.max = 100;
			position.stepSize = 5;
			position.skipSize = 20;
			super(target);
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
		}
		
		[PropertyListener(target="position.position")]						// TODO: implement in favor of Bind.addListener...
		public function onPosition(event:Event):void
		{
			if (thumb == null || track == null) {
				return;
			}
			
			var p:Point = new Point();
			if (horizontal) {
				p.x = (track.width - thumb.width) * position.percent + track.x;
				p = thumb.parent.globalToLocal( track.parent.localToGlobal(p) );
				thumb.x = Math.round(p.x);
			} else {
				p.y = (track.height - thumb.height) * position.percent + track.y;
				p = thumb.parent.globalToLocal( track.parent.localToGlobal(p) );
				thumb.y = Math.round(p.y);
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
			forwardPress = (horizontal ? track.parent.mouseX - track.x : track.parent.mouseY - track.y) > (size * position.percent);
			
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
			var forwardHold:Boolean = (horizontal ? track.parent.mouseX - track.x : track.parent.mouseY - track.y) > (size * position.percent);
			
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
		
		[EventListener(type="press", target="thumb")]
		public function onThumbPress(event:ButtonEvent):void
		{
			dragPoint = horizontal ? thumb.parent.mouseX - thumb.x : thumb.parent.mouseY;
			dragPosition = position.percent;
			event.updateAfterEvent();
		}
		
		[EventListener(type="drag", target="thumb")]
		public function onThumbDrag(event:ButtonEvent):void
		{
			var size:Number = horizontal ? track.width - thumb.width : track.height - thumb.height;
			var mousePoint:Number = horizontal ? thumb.parent.mouseX : thumb.parent.mouseY;
			var delta:Number = (mousePoint - dragPoint) / size;
			position.percent = dragPosition + delta;
		}
		
	}
}
