package reflex.animation
{
	
	import reflex.framework.IMeasurable;
	
	public class Animator implements IAnimator
	{
		public function Animator()
		{
		}
		
		public function createAnimationToken(renderer:Object):AnimationToken {
			try { // todo: sometimes renderer is still data - but it shouldn't be - check container content validate() call
				var token:AnimationToken = new AnimationToken(renderer.x, renderer.y, renderer.width, renderer.height);
			} catch(error:Error) {
				return new AnimationToken(0, 0, 0, 0);
			}
			//token.alpha = renderer.alpha;
			//if(renderer is DisplayObject) { token.matrix = renderer.transform.matrix; }
			return token;
		}
		
		
		public function begin():void {}
		
		public function moveItem(item:Object, token:AnimationToken, type:String):void
		{
			move(item, token);
		}
		
		public function end():void {}
		
		private function move(item:Object, token:AnimationToken):void {
			try { // todo: sometimes renderer is still data - but it shouldn't be - check container content validate() call
			item.x = token.x;
			item.y = token.y;
			
			if(item is IMeasurable) {
				(item as IMeasurable).setSize(token.width, token.height);
			} else {
				item.width = token.width;
				item.height = token.height;
			}
			//item.rotationZ = token.rotation;
			//if(item is DisplayObject) {
			//item.transform.matrix = token.matrix;
			//}
			} catch (e:Error) {
				
			}
		}
		
	}
}