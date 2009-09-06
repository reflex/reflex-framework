package reflex.core
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	
	public class Component extends MovieClip implements IBehavioral, ISkinnable
	{
		
		[Bindable] public var behavior:IBehavior;
		
		private var _skin:ISkin; [Bindable]
		public function get skin():ISkin { return _skin; }
		public function set skin(value:ISkin):void {
			removeSkin(_skin);
			_skin = value;
			addSkin(_skin);
		}
		
		private function removeSkin(skin:ISkin):void {
			if(skin) {
				if(skin is DisplayObject && this.contains(skin as DisplayObject)) {
					this.removeChild(skin as DisplayObject);
				}
				skin.data = null;
			}
		}
		
		private function addSkin(skin:ISkin):void {
			if(skin) {
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