package reflex.display
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class FlashDisplayHelper implements IDisplayHelper
	{
		
		//public function getDisplayItem():Object { return sprite; }
		
		public function getGraphics(instance:Object):Graphics {
			return instance.graphics as Graphics;
		}
		
		public function getNumChildren(instance:Object):int {
			if(instance) {
				return instance.numChildren;
			} else {
				return 0;
			}
		}
		
		public function contains(instance:Object, child:Object):Boolean {
			if(instance == null || child == null) { return false; }
			if(child is StyleableItem) { child = child.display; }
			if(child != null) {
				return instance.contains(child);
			} else {
				return false;
			}
		}
		
		public function addChild(instance:Object, child:Object):Object {
			if(instance == null || child == null) { return null; }
			if(child is StyleableItem) { child = child.display; }
			if(child != null) {
				return instance.addChild(child);
			} else {
				return null;
			}
		}
		
		public function addChildAt(instance:Object, child:Object, index:int):Object {
			if(instance) {
				return instance.addChildAt(child, index);
			} else {
				return null;
			}
		}
		
		public function removeChild(instance:Object, child:Object):Object {
			if(instance == null || child == null) { return null; }
			if(child is StyleableItem) { child = child.display; }
			if(child != null) {
				return instance.removeChild(child);
			} else {
				return null;
			}
		}
		
		public function removeChildAt(instance:Object, index:int):Object {
			return instance.removeChildAt(index);
		}
		
		public function removeChildren(instance:Object):void {
			instance.removeChildren();
		}
		
	}
}