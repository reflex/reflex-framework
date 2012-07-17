package reflex.behaviors
{
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import reflex.events.ContainerEvent;
	import reflex.features.IDragManager;
	import reflex.framework.IDataContainer;
	
	public class DragListBehavior extends Behavior
	{
		
		private var _container:IDataContainer;
		private var renderers:Array;
		
		[Inject]
		public var drag:IDragManager;
		
		[Bindable(event="containerChange")]
		[Binding(target="target.skin.container")]
		public function get container():IDataContainer { return _container; }
		public function set container(value:IDataContainer):void {
			var renderer:IEventDispatcher;
			if(_container) {
				(_container as IEventDispatcher).removeEventListener(ContainerEvent.ITEM_ADDED, onItemAdded, false);
				while(renderers.length > 0) {
					renderer = renderers.pop() as IEventDispatcher;
					renderer.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false);
				}
			}
			notify("container", _container, _container = value);
			if(_container) {
				(_container as IEventDispatcher).addEventListener(ContainerEvent.ITEM_ADDED, onItemAdded, false, 0, true);
				renderers = _container.getRenderers();
				
				for each(renderer in renderers) {
					renderer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
				}
			}
		}
		
		[EventListener(event="itemAdded", target="container")]
		public function onItemAdded(event:ContainerEvent):void
		{
			var renderer:IEventDispatcher = event.renderer as IEventDispatcher;
			if(renderer) { renderer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true); }
		}
		
		private var renderer:Object;
		private function onMouseDown(event:MouseEvent):void {
			renderer = event.currentTarget;
			var stage:IEventDispatcher = renderer.display.stage;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
		}
		
		private function onMouseMove(event:MouseEvent):void {
			
			var item:* = _container.getItemForRenderer(renderer);
			drag.doDrag(renderer, item);
			var stage:IEventDispatcher = event.currentTarget as IEventDispatcher;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
			//stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseMove, false);
		}
		
		private function onMouseUp(event:MouseEvent):void {
			var stage:IEventDispatcher = event.currentTarget as IEventDispatcher;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseMove, false);
			drag.endDrag();
		}
		
	}
}