package flight.list
{
	import flash.events.EventDispatcher;
	
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.selection.IListSelection;
	import flight.selection.ListSelection;
	
	use namespace list_internal;
	
	[Event(name="listChange", type="flight.events.ListEvent")]
	
	[Bindable]
	public class ArrayList extends EventDispatcher implements flight.list.IList
	{
		public var idField:String = "id";	// TODO: replace with dataMap
		
		list_internal var _source:*;		// internally available to XMLListAdapter
		
		private var adapter:*;
		private var _selection:ListSelection;
		private var _mxlist:MXList;
		
		public function ArrayList(source:* = null)
		{
			this.source = source || [];
		}
		
		[Bindable(event="listChange")]
		public function get length():int
		{
			return adapter.length;
		}
		
		public function get mxlist():MXList
		{
			if (_mxlist == null) {
				_mxlist = new MXList(this);
			}
			return _mxlist;
		}
		
		public function get selection():IListSelection
		{
			if (_selection == null) {
				_selection = new ListSelection(this);
			}
			return _selection;
		}
		
		public function get source():*
		{
			return _source;
		}
		public function set source(value:*):void
		{
			if (value == null) {
				value = [];
			} else if (_source == value) {
				return;
			}
			
			if (value is XMLList) {
				_source = value;
				adapter = new XMLListAdapter(this);
			} else {
				_source = ("splice" in value) ? value : [value];
				adapter = _source;
			}
			dispatchEvent(new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.RESET));
		}
		
		public function addItem(item:Object):Object
		{
			var oldValue:int = adapter.length;
			adapter.push(item);
			dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.ADD,
										 adapter.slice(oldValue, oldValue+1), oldValue) );
			return item;
		}
		
		public function addItemAt(item:Object, index:int):Object
		{
			if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			}
			adapter.splice(index, 0, item);
			dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.ADD,
										 adapter.slice(index, index+1), index) );
			return item;
		}
		
		public function addItems(items:*, index:int = 0x7FFFFFFF):*
		{
			// empty list
			if (items[0] === undefined) {
				return items;
			}
			
			var oldValue:int = adapter.length;
			if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			} else if (index > oldValue) {
				index = oldValue;
			}
			adapter.splice.apply(adapter, [index, 0].concat(items));
			dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.ADD, items, index) );
			return items;
		}
		
		public function containsItem(item:Object):Boolean
		{
			return Boolean(adapter.indexOf(item) != -1);
		}
		
		public function getItemAt(index:int):Object
		{
			if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			}
			return _source[index];
		}
		
		public function getItemById(id:String):Object
		{
			for each (var item:Object in _source) {
				if (idField in item && item[idField] == id) {
					return item;
				}
			}
			return null;
		}
		
		public function getItemIndex(item:Object):int
		{
			return adapter.indexOf(item);
		}
		
		public function getItems(index:int=0, length:int = 0x7FFFFFFF):*
		{
			if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			}
			length = Math.max(length, 0);
			return adapter.slice(index, length+index);
		}
		
		public function removeItem(item:Object):Object
		{
			return removeItemAt(adapter.indexOf(item));
		}
		
		public function removeItemAt(index:int):Object
		{
			if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			}
			var items:* = adapter.splice(index, 1);
			// empty list
			if (items[0] !== undefined) {
				dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.REMOVE, items, index) );
			}
			return items[0];
		}
		
		public function removeItems(index:int=0, length:int = 0x7FFFFFFF):*
		{
			if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			}
			var items:* = adapter.splice(index, length);
			// empty list
			if (items[0] !== undefined) {
				dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.REMOVE, items, index) );
			}
			return items;
		}
		
		public function setItemAt(item:Object, index:int):Object
		{
			if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			}
			adapter.splice(index, 0, item);
			var items:* = adapter.slice(index, index + 2);
			adapter.splice(index + 1, 1);
			
			dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.REPLACE, items, index) );
			return item;
		}
		
		public function setItemIndex(item:Object, index:int):Object
		{
			var oldIndex:int = adapter.indexOf(item);
			if (oldIndex == -1) {
				return addItemAt(item, index);
			} else if (index < 0) {
				index = Math.max(adapter.length + index, 0);
			}
			
			var items:* = adapter.splice(oldIndex, 1);
			adapter.splice(index, 0, item);
			dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.MOVE, items, index, oldIndex) );
			return item;
		}
		
		public function swapItems(item1:Object, item2:Object):void
		{
			var index1:int = adapter.indexOf(item1);
			var index2:int = adapter.indexOf(item2);
			swapItemsAt(index1, index2);
		}
		
		public function swapItemsAt(index1:int, index2:int):void
		{
			if (index1 > index2) {
				var temp:int = index1;
				index1 = index2;
				index2 = temp;
			}
			
			var item1:Object = _source[index1];
			var item2:Object = _source[index2];
			
			var items:* = adapter.splice(index2, 1);
			if (items is XMLList) {
				items += adapter.splice(index1, 1, item2);
			} else {
				items.push( adapter.splice(index1, 1, item2) );
			}
			adapter.splice(index2, 0, item1);
			dispatchEvent( new ListEvent(ListEvent.LIST_CHANGE, ListEventKind.MOVE, items, index1, index2) );
		}
		
		public function equals(value:Object):Boolean
		{
			if ("source" in value) {
				value = value["source"];
			}
			
			for (var i:int = 0; i < adapter.length; i++) {
				if (_source[i] != value[i]) {
					return false;
				}
			}
			return true;
		}
		
		public function clone():Object
		{
			return new ArrayList( adapter.concat() );
		}
		
	}
}

import flight.list.ArrayList;
import flight.list.IList;
import flight.selection.ListSelection;

namespace list_internal;

class XMLListAdapter
{
	use namespace list_internal;
	
	public var source:XMLList;
	public var list:ArrayList;
	
	public function get length():uint
	{
		return source.length();
	}
	
	public function XMLListAdapter(list:ArrayList)
	{
		this.list = list;
		source = list.source;
	}
	
	public function indexOf(searchElement:*, fromIndex:int = 0):int
	{
		for (var i:int = 0; i < source.length(); i++) {
			if (source[i] == searchElement) {
				return i;
			}
		}
		return -1;
	}
	
	public function concat(... args):XMLList
	{
		var items:XMLList = source.copy();
		for each (var xml:Object in args) {
			items += xml;
		}
		return items;
	}
	
	public function push(... args):uint
	{
		for each (var node:XML in args) {
			source += node;
		}
		list._source = source;
		return source.length();
	}
	
	public function slice(startIndex:int = 0, endIndex:int = 0x7FFFFFFF):XMLList
	{
		if (startIndex < 0) {
			startIndex = Math.max(source.length() + startIndex, 0);
		}
		if (endIndex < 0) {
			endIndex = Math.max(source.length() + endIndex, 0);
		}
		
		// remove trailing items
		var items:XMLList = source.copy();
		while (endIndex < items.length()) {
			delete items[endIndex];
		}
		
		// now remove from the front
		endIndex = items.length() - startIndex;
		while (endIndex < items.length()) {
			delete items[0];
		}
		
		return items;
	}
		
	public function splice(startIndex:int, deleteCount:uint, ... values):XMLList
	{
		startIndex = Math.min(startIndex, source.length());
		if (startIndex < 0) {
			startIndex = Math.max(source.length() + startIndex, 0);
		}
		
		// remove deleted items
		var deletedItems:XMLList = new XMLList();
		for (var i:int = 0; i < deleteCount; i++) {
			deletedItems += source[startIndex];
			delete source[startIndex];
		}
		
		// build values to insert
		var insertedItems:XMLList = new XMLList();
		for each (var item:Object in values) {
			insertedItems += item;
		}
		source[startIndex] = (startIndex < source.length()) ?
							 insertedItems + source[startIndex] :
							 insertedItems;
		
		list._source = source;
		return deletedItems;
	}
	
}
