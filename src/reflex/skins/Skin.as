package reflex.skins
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import flight.list.IList;
	
	import reflex.core.ISkin;
	import reflex.core.ISkinnable;

	public class Skin implements ISkin
	{
		[Bindable]
		public var state:String;
		
		private var _target:Sprite; [Bindable]
		public function get target():Sprite { return _target; }
		public function set target(value:Sprite):void {
			_target = value;
			updateChildren();
		}
		
		public function getSkinPart(part:String):InteractiveObject
		{
			return null;
		}
		
		protected function updateChildren():void {
		}
		
	}
}