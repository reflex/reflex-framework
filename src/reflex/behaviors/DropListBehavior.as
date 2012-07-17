package reflex.behaviors
{
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import reflex.containers.IContainer;
	import reflex.features.IDragManager;
	
	public class DropListBehavior extends Behavior
	{
		
		private var _container:IContainer;
		
		[Inject]
		public var drag:IDragManager;
		
		[Bindable(event="containerChange")]
		[Binding(target="target.skin.container")]
		public function get container():IContainer { return _container; }
		public function set container(value:IContainer):void {
			var renderer:IEventDispatcher;
			if(_container) {
				//(_container as IEventDispatcher).removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false);
			}
			notify("container", _container, _container = value);
			if(_container) {
				//(_container as IEventDispatcher).addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			}
		}
		/*
		private function onMouseOver(event:MouseEvent):void {
			if(drag.isDragging()) {
				//this.addEventListener(DragEvent.DRAG_DROP, onDragDrop, false, 0, true);
				drag.acceptDragDrop(container);
			}
		}
		*/
	}
}