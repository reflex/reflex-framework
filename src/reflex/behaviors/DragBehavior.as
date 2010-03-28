package reflex.behaviors
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import reflex.events.ButtonEvent;
	
	public class DragBehavior extends Behavior
	{
		private var startMouse:Point;
		private var startPosition:Point;
		
		public function DragBehavior(target:InteractiveObject=null)
		{
			super(target);
			bindEventListener("mouseDown", onMouseDown, "target");
			bindEventListener("drag", onDrag, "target");
		}
		
		override public function set target(value:InteractiveObject):void
		{
			if (value != null) {
				ButtonEvent.initialize(value);
			}
			super.target = value;
		}
		
		
		// ====== Event Listeners ====== //
		
		protected function onMouseDown(event:MouseEvent):void
		{
			startMouse = new Point(event.stageX, event.stageY);
			startPosition = new Point(target.x, target.y);
			startPosition = target.parent.localToGlobal(startPosition);
		}
		
		protected function onDrag(event:MouseEvent):void
		{
			var mouse:Point = new Point(event.stageX, event.stageY);
			var delta:Point = mouse.subtract(startMouse);
			var position:Point = startPosition.add(delta);
			position = target.parent.globalToLocal(position);
			target.x = position.x;
			target.y = position.y;
			event.updateAfterEvent();
		}
	}
}