package mx.states
{
	import flash.display.DisplayObject;
	
	import mx.collections.IList;
	import mx.core.DeferredInstanceFromFunction;

	public class AddItems extends OverrideBase implements IOverride
	{ 
		
		static public const FIRST:String = "first";
		static public const BEFORE:String = "before";
		static public const AFTER:String = "after";
		static public const LAST:String = "last";
		
		public var itemsFactory:*;
		public var destination:*;
		public var propertyName:String;
		public var position:String;
		
		private var item:*; // garbage collection?
		
		public function initialize():void {
			//trace("init");
		}
		
		public function apply(parent:DisplayObject):void {
			var object:* = parent[propertyName];
			item = (itemsFactory as DeferredInstanceFromFunction).getInstance();
			if(object is IList) {
				applyToList(object as IList, item);
			} /*else if(object is Array) {
				applyToArray(object as Array, item);
			}*/
		}
		
		public function remove(parent:DisplayObject):void {
			var object:* = parent[propertyName];
			if(object is IList) {
				removeFromList(object as IList, item);
			}
			item = null;
		}
		
		private function applyToList(list:IList, item:*):void {
			var index:int = getInsertIndex(position, list.length);
			list.addItemAt(item, index);
		}
		/*
		private function applyToArray(array:Array, item:*):void {
			var index:int = getInsertIndex(position, array.length);
			array[index] = item;
		}
		*/
		
		private function removeFromList(list:IList, item:*):void {
			var index:int = list.getItemIndex(item);
			list.removeItemAt(index);
		}
		
		private function getInsertIndex(position:String, length:int):int {
			switch(position) {
				case FIRST: return 0;
				case LAST: return length-1;
			}
			return -1;
		}
		
	}
}