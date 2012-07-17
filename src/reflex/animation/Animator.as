package reflex.animation
{
	import flash.display.DisplayObject;
	
	import reflex.display.MeasurableItem;
	
	public class Animator implements IAnimator
	{
		public function Animator()
		{
		}
		
		public function createAnimationToken(renderer:Object):AnimationToken {
			return new AnimationToken(renderer.x, renderer.y, renderer.width, renderer.height)
		}
		
		//public function attach(container:Object):void {}
		//public function detach(container:Object):void {}
		
		public function begin():void
		{
		}
		/*
		public function addItem(item:Object):void
		{
			
		}
		*/
		public function moveItem(item:Object, token:AnimationToken, type:String):void
		{
			move(item, token);
		}
		/*
		public function adjustItem(item:Object, token:AnimationToken):void
		{
			move(item, token);
		}
		
		public function removeItem(item:Object, callback:Function):void
		{
			if(callback != null) { callback(item); }
		}
		*/
		public function end():void {}
		
		private function move(item:Object, token:AnimationToken):void {
			item.x = token.x;
			item.y = token.y;
			
			if(item is MeasurableItem) {
				(item as MeasurableItem).setSize(token.width, token.height);
			} else {
				item.width = token.width;
				item.height = token.height;
			}
		}
		
	}
}