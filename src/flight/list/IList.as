package flight.list
{
	import flash.events.IEventDispatcher;
	
	import flight.selection.IListSelection;
	
	public interface IList extends IEventDispatcher
	{
		function get length():int;
		function get selection():IListSelection;
		
		function addItem(item:Object):Object;
		function addItemAt(item:Object, index:int):Object;
		function addItems(items:*, index:int = 0x7FFFFFFF):*;
		function containsItem(item:Object):Boolean;
		function getItemAt(index:int):Object;
		function getItemById(id:String):Object;
		function getItemIndex(item:Object):int;
		function getItems(index:int = 0, length:int = 0x7FFFFFFF):*;
		function removeItem(item:Object):Object;
		function removeItemAt(index:int):Object;
		function removeItems(index:int = 0, length:int = 0x7FFFFFFF):*;
		function setItemAt(item:Object, index:int):Object;
		function setItemIndex(item:Object, index:int):Object;
		function swapItems(item1:Object, item2:Object):void
		function swapItemsAt(index1:int, index2:int):void
		
	}
}