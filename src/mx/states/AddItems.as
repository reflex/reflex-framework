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
		public var relativeTo:Array = [];
		
		public var destructionPolicy:String;
		
		private var item:*; // garbage collection?
		
		override public function initialize():void {
			//trace("init");
		}
		
		override public function apply(parent:Object):void {
			var object:* = getOverrideContext(destination, parent);
			item = (itemsFactory as DeferredInstanceFromFunction).getInstance();
			if(propertyName == null || propertyName == "mxmlContent") {
				parent.addElement(item);
			} else if(object[propertyName] is IList) {
				applyToList(parent, object, item);
			} /*else if(object is Array) {
				applyToArray(object as Array, item);
			}*/
		}
		
		override public function remove(parent:Object):void {
			var object:* = getOverrideContext(destination, parent);
			if(propertyName == null || propertyName == "mxmlContent") {
				parent.removeElement(item);
			} else if(object[propertyName] is IList) {
				removeFromList(parent, object, item);
			}
			item = null;
		}
		
		private function applyToList(parent:Object, object:*, item:*):void {
			var index:int = getInsertIndex(parent, position, object);
			(object[propertyName] as IList).addItemAt(item, index);
		}
		/*
		private function applyToArray(array:Array, item:*):void {
			var index:int = getInsertIndex(position, array.length);
			array[index] = item;
		}
		*/
		
		private function removeFromList(parent:Object, object:*, item:*):void {
			var index:int = (object[propertyName] as IList).getItemIndex(item);
			(object[propertyName] as IList).removeItemAt(index);
		}
		
		private function getInsertIndex(parent:Object, position:String, dest:*):int {
			switch(position) {
				case FIRST: return 0;
				case LAST: return (dest[propertyName] as IList).length; // last = added to new index
				case AFTER: return getRelatedIndex(parent, dest)+1;
				case BEFORE: return getRelatedIndex(parent, dest);
			}
			return -1;
		}
		
		private function getRelatedIndex(parent:Object, object:Object):int {
			if(relativeTo is Array) {
			
				for(var i:int = 0; i < relativeTo.length; i++) {
					if(parent[relativeTo[i]]) {
						return getObjectIndex(parent[relativeTo[i]], object);
					}
				}
			
			}
			return -1;
		}
		
		private function getObjectIndex(child:Object, parent:Object):int {
			if(parent[propertyName] is IList) {
				return (parent[propertyName] as IList).getItemIndex(child);
			}
			return -1;
		}
		
	}
}