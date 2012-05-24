package reflex.display
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
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
			return instance.contains(child as DisplayObject);
		}
		
		public function addChild(instance:Object, child:Object):Object {
			if(instance && child) {
				return instance.addChild(child as DisplayObject);
			} else {
				return null;
			}
		}
		
		public function addChildAt(instance:Object, child:Object, index:int):Object {
			if(instance) {
				return instance.addChildAt(child as DisplayObject, index);
			} else {
				return null;
			}
		}
		
		public function removeChild(instance:Object, child:Object):Object {
			return instance.removeChild(child as DisplayObject);
		}
		
		public function removeChildAt(instance:Object, index:int):Object {
			return instance.removeChildAt(index);
		}
		
		public function removeChildren(instance:Object):void {
			instance.removeChildren();
		}
		
	}
}