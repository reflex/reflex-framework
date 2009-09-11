package reflex.core
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	
	public class Component extends MovieClip implements IBehavioral, ISkinnable
	{
		
		[Bindable] public var behavior:IBehavior;
		
		private var _skin:Object; [Bindable]
		public function get skin():Object { return _skin; }
		public function set skin(value:Object):void {
			removeSkin(_skin);
			_skin = value;
			addSkin(_skin);
		}
		
		private function removeSkin(skin:Object):void {
			if(skin && skin is ISkin) {
				if(skin is DisplayObject && this.contains(skin as DisplayObject)) {
					this.removeChild(skin as DisplayObject);
				}
				skin.data = null;
			}
		}
		
		private function addSkin(skin:Object):void {
			if(skin && skin is ISkin) {
				skin.data = this;
				if(skin is DisplayObject) {
					this.addChild(skin as DisplayObject);
				}
			}
		}
		
		// todo: Invalidation
		// todo: Measurement
		
	}
}