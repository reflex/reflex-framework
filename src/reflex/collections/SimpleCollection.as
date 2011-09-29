package reflex.collections
{
	import flash.events.EventDispatcher;
	
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	[DefaultProperty("source")]
	public class SimpleCollection extends EventDispatcher implements IList
	{
		
		private var _source:Array;
		
		public function get source():Array { return _source; }
		public function set source(value:Array):void {
			_source = value;
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET, -1, -1, (_source == null) ? null : _source.concat());
			dispatchEvent(event);
		}
		
		public function SimpleCollection(source:Array = null)
		{
			super();
			if (source == null) {
				source = [];
			}
			_source = source;
		}
		
		[Bindable(event="collectionChange")]
		public function get length():int
		{
			return _source.length;
		}
		
		public function addItem(item:Object):void
		{
			var index:uint = _source.push(item)-1;
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, -1, [item]);
			dispatchEvent(event);
		}
		
		public function addItemAt(item:Object, index:int):void
		{
			_source.splice(index, 0, item);
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, -1, [item]);
			dispatchEvent(event);
		}
		
		public function getItemAt(index:int, prefetch:int=0):Object
		{
			// todo: implement prefetch
			return _source[index];
		}
		
		public function getItemIndex(item:Object):int
		{
			return _source.indexOf(item);
		}
		
		public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null):void
		{
			// bah
		}
		
		public function removeAll():void
		{
			_source = [];
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET, -1, -1, null);
			dispatchEvent(event);
		}
		
		public function removeItemAt(index:int):Object
		{
			var item:Object = _source.splice(index, 1);
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, index, item as Array);
			dispatchEvent(event);
			return item[0];
		}
		
		public function setItemAt(item:Object, index:int):Object
		{
			var oldItem:Object = _source.splice(index, 1, item);
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REPLACE, index, index, [item]);
			dispatchEvent(event);
			return oldItem;
		}
		
		public function toArray():Array
		{
			return _source.concat();
		}
	}
}