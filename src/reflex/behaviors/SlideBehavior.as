package reflex.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import reflex.binding.DataChange;
	import reflex.data.IPosition;
	import reflex.data.IRange;
	import reflex.data.IPagingPosition;
	import reflex.data.Position;
	import reflex.data.Range;
	import reflex.invalidation.Invalidation;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	import reflex.metadata.resolveCommitProperties;
	
	public class SlideBehavior extends Behavior// extends StepBehavior
	{
		
		private var _track:Object;
		private var _thumb:Object;
		private var _position:IPosition;
		
		public var page:Boolean = false;
		
		[Bindable]
		[Binding(target="target.skin.track")]
		public function get track():Object { return _track; }
		public function set track(value:Object):void {
			DataChange.change(this, "track", _track, _track = value);
		}
		
		[Bindable]
		[Binding(target="target.skin.thumb")]
		public function get thumb():Object { return _thumb; }
		public function set thumb(value:Object):void {
			DataChange.change(this, "thumb", _thumb, _thumb = value);
		}
		
		[Bindable]
		[Binding(target="target.position")]
		public function get position():IPosition { return _position; }
		public function set position(value:IPosition):void {
			DataChange.change(this, "position", _position, _position = value);
		}
		
		public function SlideBehavior(target:IEventDispatcher = null, page:Boolean = false) {
			super(target);
			this.page = page;
			//reflex.metadata.resolveCommitProperties(this);
		}
		
		// behavior
		
		[EventListener(type="click", target="track")]
		public function onTrackPress(event:MouseEvent):void
		{
			if(page) {
				var scroll:IPagingPosition = position as IPagingPosition;
				if(scroll) {
					var center:Number = thumb.x + thumb.width/2;
					if(event.localX < center) {
						scroll.value -= scroll.pageSize;
					} else {
						scroll.value += scroll.pageSize;
					}
				}
			} else {
				var percent:Number = event.localX/track.width;
				position.value = (position.maximum-position.minimum)*percent + position.minimum;
			}
			
			onPositionChange(null);
		}
		
		
		private var tx:Number = 0;
		
		[EventListener(type="mouseDown", target="thumb")]
		public function onThumbDown(event:MouseEvent):void
		{
			tx = thumb.mouseX;
			target.addEventListener(Event.ENTER_FRAME, onUpdatePosition, false, 0, true);
			(target as Object).stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp, false, 0, true);
			(target as Object).stage.addEventListener(Event.MOUSE_LEAVE, onThumbUp, false, 0, true);
		}
		
		private function onThumbUp(event:MouseEvent):void {
			target.removeEventListener(Event.ENTER_FRAME, onUpdatePosition, false);
			(target as Object).stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUp, false);
			(target as Object).stage.removeEventListener(Event.MOUSE_LEAVE, onThumbUp, false);
		}
		
		private function onUpdatePosition(event:Event):void {
			var percent:Number = (track.mouseX-track.x)/(track.width-thumb.width);
			var p:Number = (position.maximum-position.minimum)*percent + position.minimum;
			position.value = Math.max(position.minimum, Math.min(position.maximum, p));
			onPositionChange(null);
		}
		
		
		// skinpart positioning
		
		//[CommitProperties(properties="position.min, position.max, position.position, position.pageSize")]
		public function onPositionChange(event:Event):void {
			var percent:Number = (position.value-position.minimum)/(position.maximum-position.minimum);
			thumb.x = track.x + (track.width-thumb.width) * percent;
		}
		
		public function onPageSizeChange(event:Event):void {
			
		}
		
	}
}
