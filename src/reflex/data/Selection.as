package reflex.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import reflex.binding.DataChange;
	import reflex.collections.SimpleCollection;
	
	public class Selection extends EventDispatcher implements ISelection
	{
		
		private var _selectedItem:Object;
		private var _selectedItems:IList;
		
		public function Selection()
		{
			_selectedItems = new SimpleCollection();
			_selectedItems.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange, false, 0, true);
		}
		
		[Bindable(event="selectedItemChange")]
		public function get selectedItem():Object { return _selectedItem; }
		public function set selectedItem(value:Object):void {
			if (_selectedItem == value) return;

			_selectedItems.removeAll();
			if(value != null) {
				_selectedItems.addItem(value);
			}
			DataChange.change(this, "selectedItem", _selectedItem, _selectedItem = value);
			
			//dispatcheEvent(new Event("selectionChanged"));
		}
		
		public function get selectedItems():IList { return _selectedItems; }
		
		private function onCollectionChange(event:CollectionEvent):void {
			switch(event.kind) {
				case CollectionEventKind.ADD:
				case CollectionEventKind.MOVE:
				case CollectionEventKind.REPLACE:
					DataChange.change(this, "selectedItem", _selectedItem, _selectedItem = event.items[0]);
					break;
				case CollectionEventKind.REFRESH:
				case CollectionEventKind.REMOVE:
				case CollectionEventKind.RESET:
					var length:int = _selectedItems.length;
					if(length > 0) {
						DataChange.change(this, "selectedItem", _selectedItem, _selectedItem = _selectedItems.getItemAt(length-1));
					} else {
						DataChange.change(this, "selectedItem", _selectedItem, _selectedItem = null);
					}
					break;
			}
		}
		
	}
}