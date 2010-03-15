package flight.list
{
	import flash.events.EventDispatcher;
	
	import flight.binding.Bind;
	import flight.events.ListEvent;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	
	[Event(name="collectionChange", type="mx.events.CollectionEvent")]
	
	[Bindable]
	public class MXList extends EventDispatcher implements mx.collections.IList
	{
		private var list:flight.list.IList;
		
		/**
		 * Construct a new Collection using the specified Array, Vector or
		 * XMLList as its source. If no source is specified an empty Array
		 * will be used.
		 */
		public function MXList(list:flight.list.IList)
		{
			this.list = list;
			
			Bind.addBinding(this, "length", list, "length");
			list.addEventListener(ListEvent.LIST_CHANGE, onListChange);
		}
		
		/**
		 * Get the number of items in the list.
		 * 
		 * @return	int			representing the length of the source.
		 */
		public function get length():int
		{
			return list.length;
		}
		
		/**
		 * Add the specified item to the end of the list.
		 * 
		 * @param	item			the item to add
		 */
		public function addItem(item:Object):void
		{
			list.addItem(item);
		}
		
		/**
		 * Add the item at the specified index.  
		 * Any item that was after this index is moved out by one.  
		 * 
		 * @param	item			the item to place at the index
		 * @param	index			the index at which to place the item
		 */
		public function addItemAt(item:Object, index:int):void
		{
			list.addItemAt(item, index);
		}
		
		/**
		 * Get the item at the specified index.
		 * 
		 * @param	index			the index from which to retrieve the item
		 * @param	prefetch		unused in this implementation of IList.
		 * 
		 * @return					the item at the specified index
		 */
		public function getItemAt(index:int, prefetch:int=0):Object
		{
			return list.getItemAt(index);
		}
		
		/**
		 * Returns the index of the item in the collection.
		 * 
		 * @param	item			the item to find
		 * 
		 * @return					the index of the item, or -1 if the item is
		 * 							unnavailable.
		 */
		public function getItemIndex(item:Object):int
		{
			return list.getItemIndex(item);
		}
		
		/**
		 * Currently not implemented.
		 */
		public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void
		{
		}
		
		/** 
		 *  Remove all items from the list.
		 */
		public function removeAll():void
		{
			list.removeItems();
		}
		
		/**
		 * Removes the specified item from this list, should it exist.
		 * 
		 * @param	item			the item that should be removed
		 * @return					the item that was removed
		 */
		public function removeItem(item:Object):Object
		{
			return list.removeItem(item);
		}
		
		/**
		 * Remove the item at the specified index and return it.
		 * Any items that were after this index are now one index earlier.
		 * 
		 * @param	index			the index from which to remove the item
		 * @return					the item that was removed
		 */
		public function removeItemAt(index:int):Object
		{
			return list.removeItemAt(index);
		}
		
		/**
		 * Place the item at the specified index.  
	     * If an item was already at that index the new item will replace it and it 
	     * will be returned.
		 * 
		 * @param	item			item the new value for the index
		 * @param	index			the index at which to place the item
		 * 
		 * @return					the item that was replaced, null if none
		 */
		public function setItemAt(item:Object, index:int):Object
		{
			var oldItem:Object = list.removeItemAt(index);
			list.addItemAt(item, index);
			return oldItem;
		}
		
		/**
		 * Return an Array that is populated in the same order as the IList
		 * implementation.
		 */ 
		public function toArray():Array
		{
			return list.getItems() as Array;
		}
		
		private function onListChange(event:ListEvent):void
		{
			var collEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
				collEvent.kind = event.kind;
				collEvent.items = [].concat(event.items);
				collEvent.location = event.location1;
				collEvent.oldLocation = event.location2;
			dispatchEvent(collEvent);
		}
		
	}
}