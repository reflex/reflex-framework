package reflex.skins
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import reflex.core.IContainer;
	import reflex.core.ISkin;
	import reflex.graphics.IDrawable;
	
	public class Skin implements ISkin, IContainer
	{
		
		private var _data:Object; [Bindable]
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			_data = value;
			updateChildren(_content);
		}
		
		private var _content:Array; [Bindable]
		public function get content():Array { return _content; }
		public function set content(value:Array):void {
			_content = value;
			updateChildren(_content);
		}
		
		public function Skin()
		{
			super();
		}
		
		private function updateChildren(children:Array):void {
			if(data is DisplayObjectContainer) {
				var length:int = children.length;
				var component:DisplayObjectContainer = data as DisplayObjectContainer;
				for(var i:int = 0; i < length; i++) {
					var child:Object = children[i];
					if(child is DisplayObject) {
						component.addChild(child as DisplayObject);
					} else if(child is IDrawable) {
						(child as IDrawable).target = component;
					}
				}
			}
		}
		
	}
}