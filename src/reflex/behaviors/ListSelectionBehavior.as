package reflex.behaviors
{
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import mx.collections.IList;
	import mx.core.IDataRenderer;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import reflex.containers.IContainer;
	import reflex.data.ISelection;
	
	public class ListSelectionBehavior extends Behavior
	{
		
		private var _container:IContainer;
		private var _selection:ISelection;
		
		protected var _renderers:IList;
		/*
		[Bindable(event="containerChanged")]
		[Binding(target="target.skin.container")]
		public function get container():IContainer { return _container; }
		public function set container(value:IContainer):void {
			addContainer(value);
			notify("container", _container, _container = value);
		}
		*/
		
		[Bindable(event="renderersChanged")]
		[Binding(target="target.skin.container.renderers")]
		public function get renderers():IList { return _renderers; }
		public function set renderers(value:IList):void {
			notify("renderers", _renderers, _renderers = value);
			addItems(_renderers ? _renderers.toArray() : [], 0);
			_renderers.addEventListener(CollectionEvent.COLLECTION_CHANGE, onChildrenChange, false, 0, true);
		}
		
		[Bindable(event="selectionChanged")]
		[Binding(target="target.selection")]
		public function get selection():ISelection{ return _selection; }
		public function set selection(value:ISelection):void {
			notify("selection", _selection, _selection= value);
		}
		
		public function ListSelectionBehavior(target:IEventDispatcher=null):void {
			super(target);
		}
		
		private var _cancel:Boolean;
		public function cancel():void {
			_cancel = true;
			//_container.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
		}
		/*
		//[EventListener(event="added", target="container")]
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
		
		private function addContainer(container:IContainer):void {
			if(container) {
				var renderers:Array = container.g
				var length:int = container.numChildren;
				for(var i:int = 0; i < length; i++) {
					var renderer:IEventDispatcher = container.getChildAt(i);
					addRenderer(renderer);
				}
				container.addEventListener(Event.ADDED, onRendererAdded);
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
		*/
		
		private function onChildrenChange(event:CollectionEvent):void
		{
			switch (event.kind) {
				case CollectionEventKind.ADD :
					addItems(event.items, event.location);
					break;
				case CollectionEventKind.REMOVE :
					removeItems(event.items, event.oldLocation);
					break;
				/*case CollectionEventKind.REPLACE :
					animationType = AnimationType.REPLACE;
					helper.removeChild(display, event.items[1]);
					//addChildAt(event.items[0], loc);
					break;*/
				case CollectionEventKind.RESET :
				default:
					removeItems(event.items, 0);
					addItems(_renderers ? _renderers.toArray() : [], 0);
					break;
			}
		}
		
		private function addItems(items:Array, index:int):void {
			var length:int = items ? items.length : 0;
			for(var i:int = 0; i < length; i++) {
				var item:IEventDispatcher = items[i];
				item.addEventListener(MouseEvent.CLICK, onRendererClick, false, 0, true);
			}
		}
		
		private function removeItems(items:Array, index:int):void {
			for each (var item:IEventDispatcher in items) {
				item.removeEventListener(MouseEvent.CLICK, onRendererClick, false);
			}
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
					//r.selected = false;
				}
				//(renderer as Object).selected = !(renderer as Object).selected;
			}
			_cancel = false;
		}
		
		private function onMouseUp(event:MouseEvent):void {
			//_container.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
			//if(!_container.hitTestPoint(_container.stage.mouseX, _container.stage.mouseY)) {
			//	_cancel = false;
			//}
		}
		
	}
}