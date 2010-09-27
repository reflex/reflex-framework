package reflex.behaviors
{
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import reflex.binding.DataChange;
	import reflex.data.IPosition;
	import reflex.data.IRange;
	//import reflex.events.ButtonEvent;
	
	public class DragStepBehavior extends Behavior
	{
		
		private var _position:IPosition;
		
		[Bindable(event="positionChange")]
		[Binding(target="target.position")]
		public function get position():IPosition { return _position; }
		public function set position(value:IPosition):void {
			DataChange.change(this, "position", _position, _position = value);
		}
		
		public var increment:Number = 1;
		public var dragTolerance:Number = 3;
		public var dragging:Boolean = false;
		
		private var startDragPosition:Number;
		
		public function DragStepBehavior(target:IEventDispatcher = null)
		{
			super(target);
		}
		
		override public function set target(value:IEventDispatcher):void
		{
			super.target = value;
			
			if (target == null) {
				return;
			}
			
			//ButtonEvent.initialize(target);
		}
		
		[EventListener(type="mouseDown", target="target")]
		public function onDragStart(event:MouseEvent):void
		{
			startDragPosition = position.value;
		}
		
		[EventListener(type="drag", target="target")]
		public function onDrag(event:Event):void
		{
			if (dragging) {
				//position.value = Math.round( (startDragPosition + event.deltaX) / increment) * increment;
			//} else if ( Math.abs(startDragPosition - event.deltaX) > dragTolerance) {
				//position.value = Math.round( (startDragPosition + event.deltaX) / increment) * increment;
				//dragging = true;
			}
		}
		
	}
}