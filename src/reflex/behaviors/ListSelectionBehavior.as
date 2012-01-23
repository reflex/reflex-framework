package reflex.behaviors
{
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import mx.core.IDataRenderer;
	
	import reflex.binding.DataChange;
	import reflex.data.ISelection;

	public class ListSelectionBehavior extends Behavior
	{
		
		private var _container:DisplayObjectContainer;
		private var _selection:ISelection;
		
		protected var renderers:Array = [];
		
		[Bindable(event="containerChanged")]
		[Binding(target="target.skin.container")]
		public function get container():DisplayObjectContainer { return _container; }
		public function set container(value:DisplayObjectContainer):void {
			addContainer(value);
			DataChange.change(this, "container", _container, _container = value);
		}
		
		[Bindable(event="selectionChanged")]
		[Binding(target="target.selection")]
		public function get selection():ISelection{ return _selection; }
		public function set selection(value:ISelection):void {
			DataChange.change(this, "selection", _selection, _selection= value);
		}
		
		public function ListSelectionBehavior(target:IEventDispatcher=null):void {
			super(target);
		}
		
		private var _cancel:Boolean;
		public function cancel():void {
			_cancel = true;
			_container.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
		}
		
		[EventListener(event="added", target="container")]
		public function onRendererAdded(event:Event):void {
			var renderer:Object = event.target;
			if(renderer.parent == container || renderer.parent.parent == container) {
				addRenderer(renderer as IEventDispatcher)
			}
		}
		
		public function onRendererRemoved(event:Event):void {
			var renderer:IEventDispatcher= event.target as IEventDispatcher
			removeRenderer(renderer)
		}
		
		private function addContainer(container:DisplayObjectContainer):void {
			if(container) {
				var length:int = container.numChildren;
				for(var i:int = 0; i < length; i++) {
					var renderer:IEventDispatcher = container.getChildAt(i);
					addRenderer(renderer);
				}
			}
		}
		
		private function addRenderer(renderer:IEventDispatcher):void {
			renderer.addEventListener(MouseEvent.CLICK, onRendererClick, false, 0, true);
			renderers.push(renderer);
		}
		
		private function removeRenderer(renderer:IEventDispatcher):void {
			renderer.removeEventListener(MouseEvent.CLICK, onRendererClick, false);
			var index:int = renderers.indexOf(renderer);
			renderers.splice(index, 1);
		}
		
		private function onRendererClick(event:MouseEvent):void {
			if(!_cancel) {
				// just assuming IDataRenderer for now. this will need to be smarter later
				var renderer:Object = event.currentTarget;
				var item:Object = (event.currentTarget is IDataRenderer) ? (event.currentTarget as IDataRenderer).data : event.currentTarget;
				if(event.ctrlKey) {
					_selection.selectedItems.addItem(item);
				} else {
					_selection.selectedItem = item;
				}
				
				// making wild assumptions about the existence of selected properties here
				for each(var r:Object in renderers) {
					r.selected = false;
				}
				(renderer as Object).selected = !(renderer as Object).selected;
			}
			_cancel = false;
		}
		
		private function onMouseUp(event:MouseEvent):void {
			_container.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
			if(!_container.hitTestPoint(_container.stage.mouseX, _container.stage.mouseY)) {
				_cancel = false;
			}
		}
		
	}
}