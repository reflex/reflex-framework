package flight.selection
{
	import flash.events.EventDispatcher;
	
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.list.ArrayList;
	import flight.list.IList;
	
	[Bindable]
	public class ListSelection extends EventDispatcher implements IListSelection
	{
		public var multiselect:Boolean = false;
		
		private var list:IList;
		private var updatingLists:Boolean;
		private var _index:int = -1;
		private var _item:Object = null;
		private var _indices:ArrayList = new ArrayList();
		private var _items:ArrayList = new ArrayList();
		
		public function ListSelection(list:IList)
		{
			this.list = list;
			list.addEventListener(ListEvent.LIST_CHANGE, onListChange, false, 0xF);
			_indices.addEventListener(ListEvent.LIST_CHANGE, onSelectionChange, false, 0xF);
			_items.addEventListener(ListEvent.LIST_CHANGE, onSelectionChange, false, 0xF);
		}
		
		public function get index():int
		{
			return _index;
		}
		public function set index(value:int):void
		{
			value = Math.max(-1, Math.min(list.length-1, value));
			if (_index == value) {
				return;
			}
			_index = value;
			item = list.getItemAt(_index);
			
			updatingLists = true;
			_indices.source = [_index];
			_items.source = [_item];
			updatingLists = false;
		}
		
		public function get item():Object
		{
			return _item;
		}
		public function set item(value:Object):void
		{
			var i:int = list.getItemIndex(value);
			if (i == -1) {
				value = null;
			}
			if (_item == value) {
				return;
			}
			_item = value;
			index = i;
			
			updatingLists = true;
			_items.source = [_item];
			_indices.source = [_index];
			updatingLists = false;
		}
		
		public function get indices():IList
		{
			return _indices;
		}
		
		public function get items():IList
		{
			return _items;
		}
		
		public function select(items:*):void
		{
			_items.source = items;
		}
		
		private function onListChange(event:ListEvent):void
		{
			var tmpItems:Array = [];
			for (var i:int = 0; i < _items.length; i++) {
				var item:Object = _items.getItemAt(i);
				var index:int = list.getItemIndex(item);
				
				if (index != -1) {
					tmpItems.push(item);
				}
			}
			
			_items.source = tmpItems;
		}
		
		private function onSelectionChange(event:ListEvent):void
		{
			if (updatingLists) {
				return;
			}
			
			var list1:ArrayList = event.target as ArrayList;
			if (!multiselect && list1.length > 1) {
				list1.source = event.items != null ? event.items[0] : list1.getItemAt(0);
				event.stopImmediatePropagation();
				return;
			}
			
			var list2:ArrayList = (list1 == _indices) ? _items : _indices;
			var getData:Function = (list1 == _indices) ? list.getItemAt : list.getItemIndex;
			var tmpArray:Array;
			var tmpObject:Object;
			
			updatingLists = true;
			switch (event.kind) {
				case ListEventKind.ADD :
					tmpArray = [];
					for each (tmpObject in event.items) {
						tmpArray.push( getData(tmpObject) );
					}
					list2.addItems(tmpArray, event.location1);
					break;
				case ListEventKind.REMOVE :
					list2.removeItems(event.location1, event.items.length);
					break;
				case ListEventKind.MOVE :
					if (event.items.length == 1) {
						tmpObject = getData(event.items[0]);
						list2.setItemIndex(tmpObject, event.location1);
					} else {
						list2.swapItemsAt(event.location1, event.location2);
					}
					break;
				case ListEventKind.REPLACE :
					tmpObject = getData(event.items[0]);
					list2.setItemAt(tmpObject, event.location1);
					break;
				case ListEventKind.RESET :
					tmpArray = [];
					for (var i:int = 0; i < list1.length; i++) {
						tmpObject = list1.getItemAt(i);
						tmpArray.push( getData(tmpObject) );
					}
					list2.source = tmpArray;
					break;
			}
			updatingLists = false;
			
			var oldIndex:int = _index;
			var oldItem:Object = _item;
			index = _indices.length > 0 ? _indices.getItemAt(0) as Number : -1;
			item = _items.getItemAt(0);
		}
		
	}
}