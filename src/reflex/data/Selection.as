package reflex.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import reflex.collections.SimpleCollection;
	import reflex.events.DataChangeEvent;
	import reflex.display.PropertyDispatcher;
	
	[Event(name="selectedItemChange", type="reflex.events.DataChangeEvent")]
	
	/**
	 * Holds the selected data for list components.
	 */
	public class Selection extends PropertyDispatcher implements ISelection
	{
		
		private var _selectedItem:Object;
		private var _selectedItems:IList;
		
		public function Selection()
		{
			_selectedItems = new SimpleCollection();
			_selectedItems.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange, false, 0, true);
		}
		
		[Bindable(event="selectedItemChange")]
		/**
		 * The selected item related to this selection.
		 * If multiple items are selected this property will hold the most recently selected item.
		 */
		public function get selectedItem():Object { return _selectedItem; }
		public function set selectedItem(value:Object):void {
			if (_selectedItem == value) return;

			_selectedItems.removeAll();
			if(value != null) {
				_selectedItems.addItem(value);
			}
			notify("selectedItem", _selectedItem, _selectedItem = value);
			
			//dispatcheEvent(new Event("selectionChanged"));
		}
		
		/**
		 * A collection of selected items.
		 * Add new items to the selection by calling selectedItems.addItem.
		 */
		public function get selectedItems():IList { return _selectedItems; }
		
		private function onCollectionChange(event:CollectionEvent):void {
			switch(event.kind) {
				case CollectionEventKind.ADD:
				case CollectionEventKind.MOVE:
				case CollectionEventKind.REPLACE:
					notify("selectedItem", _selectedItem, _selectedItem = event.items[0]);
					break;
				case CollectionEventKind.REFRESH:
				case CollectionEventKind.REMOVE:
				case CollectionEventKind.RESET:
					var length:int = _selectedItems.length;
					if(length > 0) {
						notify("selectedItem", _selectedItem, _selectedItem = _selectedItems.getItemAt(length-1));
					} else {
						notify("selectedItem", _selectedItem, _selectedItem = null);
					}
					break;
			}
		}
		
	}
}