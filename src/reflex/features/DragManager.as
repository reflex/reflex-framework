package reflex.features
{
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import reflex.events.DragEvent;

	public class DragManager implements IDragManager
	{
		
		private var item:*;
		private var initiator:Object;
		private var target:IEventDispatcher;
		
		private var targets:Array = [];
		
		public function addTarget(instance:IEventDispatcher):void {
			targets.push(instance);
			instance.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
		}
		
		public function removeTarget(instance:IEventDispatcher):void {
			//
			instance.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false);
		}
		
		public function doDrag(initiator:Object, item:*):void {
			this.item = item;
			this.initiator = initiator;
		}
		
		public function acceptDragDrop(target:IEventDispatcher):void {
			this.target = target;
		}
		
		public function endDrag():void {
			if(target) {
				target.dispatchEvent(new DragEvent(DragEvent.DRAG_DROP, initiator, item));
			}
			initiator = null;
			item = null;
			target = null;
		}
		
		public function isDragging():Boolean {
			return initiator != null;
		}
		
		// handlers
		
		private function onMouseOver(event:MouseEvent):void {
			if(isDragging()) {
				var instance:IEventDispatcher = event.currentTarget as IEventDispatcher;
				instance.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
				instance.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
				instance.dispatchEvent(new DragEvent(DragEvent.DRAG_ENTER, initiator, item));
			}
		}
		
		private function onMouseOut(event:MouseEvent):void {
			var instance:IEventDispatcher = event.currentTarget as IEventDispatcher;
			instance.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false);
			instance.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
			instance.dispatchEvent(new DragEvent(DragEvent.DRAG_EXIT, initiator, item));
		}
		
		private function onMouseUp(event:MouseEvent):void {
			var instance:IEventDispatcher = event.currentTarget as IEventDispatcher;
			instance.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false);
			instance.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
			instance.dispatchEvent(new DragEvent(DragEvent.DRAG_DROP, initiator, item));
		}
		
	}
}