package reflex.animation
{
	import flash.display.DisplayObject;
	
	import reflex.display.Display;
	
	public class Animator implements IAnimator
	{
		public function Animator()
		{
		}
		
		//public function attach(container:Object):void {}
		//public function detach(container:Object):void {}
		
		public function begin():void
		{
		}
		
		public function addItem(item:Object):void
		{
			
		}
		
		public function moveItem(item:Object, token:AnimationToken):void
		{
			move(item, token);
		}
		
		public function adjustItem(item:Object, token:AnimationToken):void
		{
			move(item, token);
		}
		
		public function removeItem(item:Object, callback:Function):void
		{
			if(callback != null) { callback(item); }
		}
		
		public function end():void {}
		
		private function move(item:Object, token:AnimationToken):void {
			item.x = token.x;
			item.y = token.y;
			
			if(item is Display) {
				(item as Display).setSize(token.width, token.height);
			} else {
				item.width = token.width;
				item.height = token.height;
			}
		}
		
	}
}