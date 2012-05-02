package reflex.display
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class FlashDisplayHelper implements IDisplayHelper
	{
		
		//public function getDisplayItem():Object { return sprite; }
		
		public function getGraphics(instance:Object):Graphics { return instance.graphics as Graphics; }
		
		public function getNumChildren(instance:Object):int { return instance.numChildren; }
		
		public function contains(instance:Object, child:Object):Boolean {
			return instance.contains(child as DisplayObject);
		}
		
		public function addChild(instance:Object, child:Object):Object {
			return instance.addChild(child as DisplayObject);
		}
		
		public function addChildAt(instance:Object, child:Object, index:int):Object {
			return instance.addChildAt(child as DisplayObject, index);
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