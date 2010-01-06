package reflex.skin
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	import reflex.core.ISkin;

	public class GraphicSkin extends EventDispatcher implements ISkin
	{
		[Bindable]
		public var data:Object;
		
		[Bindable]
		public var state:String;
		
		protected var graphic:Sprite;
		private var _target:Sprite;
		
		public function GraphicSkin(graphic:Sprite)
		{
			this.graphic = graphic;
		}
		
		[Bindable]
		public function get target():Sprite
		{
			return _target;
		}
		public function set target(value:Sprite):void
		{
			if (_target == value) {
				return;
			}
			
			if (_target != null) {
				_target.removeChild(graphic);
			}
			
			_target = value;
			
			if (_target != null) {
				_target.addChild(graphic);
			}
		}
		
		public function getSkinPart(part:String):InteractiveObject
		{
			return (part in graphic) ? graphic[part] : null;
		}
		
		
		
	}
}