package flight.list
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.events.PropertyEvent;
	
	use namespace flash_proxy;
	use namespace list_internal;
	
	[Event(name="listChange", type="flight.events.ListEvent")]
	
	[Bindable]
	dynamic public class ArrayProxy extends Proxy implements IEventDispatcher
	{
		protected var dispatcher:EventDispatcher;
		
		list_internal var _source:*;
		private var adapter:*;
		
		public function ArrayProxy(source:* = null)
		{
			this.source = source;
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
		
		[Bindable(event="listChange")]
		public function get length():uint
		{
			return adapter.length;
		}
		public function set length(value:uint):void
		{
			adapter.length = value;
		}
		
		public function concat(...args):*
		{
			return adapter.concat.apply(adapter, args);
		}
		
		public function every(callback:Function, thisObject:Object = null):Boolean
		{
			return adapter.every(callback, thisObject);
		}
		
		public function filter(callback:Function, thisObject:Object = null):*
		{
			return adapter.filter(callback, thisObject);
		}
		
		public function forEach(callback:Function, thisObject:Object = null):void
		{
			adapter.forEach(callback, thisObject);
		}
		
		public function indexOf(searchElement:Object, fromIndex:int = 0):int
		{
			return adapter.indexOf(searchElement, fromIndex);
		}	
		
		public function join(sep:String = ","):String
		{
			return adapter.join(sep);
		}
		
		public function lastIndexOf(searchElement:Object, fromIndex:int = -1):int
		{
			return adapter.lastIndexOf(searchElement, fromIndex);
		}
		
		public function map(callback:Function, thisObject:Object = null):*
		{
			return adapter.map(callback, thisObject);
		}
		
		public function pop():Object
		{
			return adapter.pop();
		}
		
		public function push(...args):uint
		{
			return adapter.push.apply(adapter, args);
		}
		
		public function reverse():*
		{
			return adapter.reverse();
		}
		
		public function shift():Object
		{
			return adapter.shift();
		}
		
		public function slice(startIndex:int = 0, endIndex:int = -1):*
		{
			return adapter.slice(startIndex, endIndex);
		}
		
		public function some(callback:Function, thisObject:Object = null):Boolean
		{
			return adapter.some(callback, thisObject);
		}
		
//		sort(compareFunction:Function):Vector.<T>
//		function compare(x:T, y:T):Number {}
//		public function sort(...args):*
//		{
//			return adapter.sort.apply(adapter, args);
//		} 
//		
//		public function sortOn(fieldName:Object, options:Object = null):*; // 'key' is a String, or an Array of String. 'options' is optional.
//		{
//			return adapter.sortOn(fieldName, options);
//		}
		
		public function splice(startIndex:int, deleteCount:uint, ...values):*
		{
			return adapter.splice.apply(adapter, [startIndex, deleteCount].concat(values));
		}
		
		public function toString():String
		{
			return "ArrayProxy:" + _source.toString();
		}
		
		public function toLocaleString():String
		{
			return "ArrayProxy:" + _source.toLocalString();
		}
		
		public function unshift(...args):uint
		{
			return adapter.unshift.apply(args);
		}
		
		
		// ========== Serialization Methods ========== //
		
		public function readExternal(input:IDataInput):void
		{
			source = input.readObject();
		}
		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject(_source);
		}
		
		
		// ========== Proxy Methods ========== //
		
		override flash_proxy function getProperty(name:*):*
		{
			return _source[name];
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			_source[name] = value;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			return delete _source[name];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return (name in _source);
		}
		
		override flash_proxy function callProperty(name:*, ... rest):*
		{
			return adapter[name].apply(adapter, rest);
		}
		
		override flash_proxy function nextName(index:int):String
		{
			return String(index - 1);
		}
		
		override flash_proxy function nextValue(index:int):*
		{
			return _source[index - 1];
		}
		
		override flash_proxy function nextNameIndex(index:int):int
		{
			return (index + 1) % (adapter.length + 1);
		}
		
		
		// ========== Dispatcher Methods ========== //
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if (dispatcher == null) {
				dispatcher = new EventDispatcher(this);
			}
			
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			if (dispatcher != null) {
				dispatcher.removeEventListener(type, listener, useCapture);
			}
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			if (dispatcher != null && dispatcher.hasEventListener(event.type)) {
				return dispatcher.dispatchEvent(event);
			}
			return false;
		}
		
		public function hasEventListener(type:String):Boolean
		{
			if (dispatcher != null) {
				return dispatcher.hasEventListener(type);
			}
			return false;
		}
		
		public function willTrigger(type:String):Boolean
		{
			if (dispatcher != null) {
				return dispatcher.willTrigger(type);
			}
			return false;
		}
		
		protected function dispatch(type:String):Boolean
		{
			if (dispatcher != null && dispatcher.hasEventListener(type)) {
				return dispatcher.dispatchEvent( new Event(type) );
			}
			return false;
		}
		
	}
}



import flight.list.ArrayProxy;

namespace list_internal;

class XMLListAdapter
{
	use namespace list_internal;
	
	public var source:XMLList;
	public var list:ArrayProxy;
	
	public function XMLListAdapter(list:ArrayProxy)
	{
		this.list = list;
		source = list.source;
	}
	
	public function get length():uint
	{
		return source.length();
	}
	public function set length(value:uint):void
	{
	}
	
	public function concat(... args):XMLList
	{
		var items:XMLList = source.copy();
		for each (var xml:Object in args) {
			items += xml;
		}
		return items;
	}
	
	public function every(callback:Function, thisObject:Object = null):Boolean
	{
		return false;
	}
	
	public function filter(callback:Function, thisObject:Object = null):*
	{
		return null;
	}
	
	public function forEach(callback:Function, thisObject:Object = null):void
	{
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
	
	public function join(sep:String = ","):String
	{
		return null;
	}
	
	public function lastIndexOf(searchElement:Object, fromIndex:int = -1):int
	{
		return 0;
	}
	
	public function map(callback:Function, thisObject:Object = null):*
	{
		return null;
	}
	
	public function pop():Object
	{
		return null;
	}
	
	public function push(... args):uint
	{
		for each (var node:XML in args) {
			source += node;
		}
		list._source = source;
		return source.length();
	}
	
	public function reverse():*
	{
		return null;
	}
	
	public function shift():Object
	{
		return null;
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
	
	public function some(callback:Function, thisObject:Object = null):Boolean
	{
		return false;
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
	
	public function unshift(...args):uint
	{
		return 0;
	}
	
}