package reflex.behaviors
{
	
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import flight.position.IPosition;
	import flight.position.Position;
	
	import reflex.events.ButtonEvent;
	
	public class DragStepBehavior extends Behavior
	{
		[Bindable]
		[Binding(target="target.position")]
		public var position:IPosition = new Position();		// TODO: implement lazy instantiation of position
		
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
			
			ButtonEvent.initialize(target);
		}
		
		[EventListener(type="mouseDown", target="target")]
		public function onDragStart(event:MouseEvent):void
		{
			startDragPosition = position.value;
		}
		
		[EventListener(type="drag", target="target")]
		public function onDrag(event:ButtonEvent):void
		{
			if (dragging) {
				position.value = Math.round( (startDragPosition + event.deltaX) / increment) * increment;
			} else if ( Math.abs(startDragPosition - event.deltaX) > dragTolerance) {
				position.value = Math.round( (startDragPosition + event.deltaX) / increment) * increment;
				dragging = true;
			}
		}
		
	}
}