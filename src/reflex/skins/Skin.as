package reflex.skins
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import reflex.core.IContainer;
	import reflex.core.ISkin;

	public class Skin implements ISkin, IContainer
	{
		protected var graphics:Graphics;
		protected var component:DisplayObjectContainer;
		
		private var _data:Object; [Bindable]
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			_data = value;
			if(_data is DisplayObjectContainer) {
				component = _data as DisplayObjectContainer;
			}
			if(_data is Sprite || _data is Shape) {
				graphics = _data.graphics;
			}
			updateChildren(_content);
		}
		
		private var _content:Array; [Bindable]
		public function get content():Array { return _content; }
		public function set content(value:Array):void {
			_content = value;
			updateChildren(_content);
		}
		
		private function updateChildren(children:Array):void {
			if(component) {
				var length:int = children.length;
				for(var i:int = 0; i < length; i++) {
					var child:DisplayObject = children[i];
					if(child) {
						component.addChild(child);
					}
				}
			}
		}
		
	}
}