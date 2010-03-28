package reflex.behaviors
{
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import flight.binding.Bind;
	import flight.position.IPosition;
	import flight.position.Position;
	
	import reflex.events.ButtonEvent;
	
	public class DragStepBehavior extends Behavior
	{
		[Bindable]
		public var position:IPosition = new Position();		// TODO: implement lazy instantiation of position
		
		protected var startDragPosition:Number;
		
		public function DragStepBehavior(target:InteractiveObject = null)
		{
			super(target);
			bindProperty("position", "target.position");
			bindEventListener("mouseDown", onDragStart, "target");
			bindEventListener("drag", onDrag, "target");
		}
		
		override public function set target(value:InteractiveObject):void
		{
			super.target = value;
			
			if (target == null) {
				return;
			}
			
			ButtonEvent.initialize(target);
		}
		
		protected function onDragStart(event:MouseEvent):void
		{
			startDragPosition = position.value;
		}
		
		protected function onDrag(event:ButtonEvent):void
		{
			position.value = startDragPosition + event.deltaX;
		}
		
	}
}