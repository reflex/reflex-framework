package reflex.skins
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	import flight.binding.Bind;
	import flight.events.PropertyEvent;
	
	import reflex.layout.Block;
	import reflex.layout.ILayoutAlgorithm;
	import reflex.layout.Layout;
	

	public class GraphicSkin extends Skin
	{
		private var _graphic:Sprite;
		private var _graphicBlock:Block;
		
		public function GraphicSkin(graphic:Sprite)
		{
			_graphic = graphic;
			_graphicBlock = new Block(graphic);
			if ("defaultSize" in graphic) {
				trace(graphic, graphic["defaultSize"].width, graphic["defaultSize"].height);
				var defaultSize:DisplayObject = graphic["defaultSize"] as DisplayObject;
				_graphicBlock.defaultWidth = defaultSize.width;
				_graphicBlock.defaultHeight = defaultSize.height;
			}
			
			if (_graphic is MovieClip) {
				Bind.addListener(onStateChange, this, "state");
			}
		}
		
		override public function set target(value:Sprite):void
		{
			if (target == value) {
				return;
			}
			
			if (target != null && target != graphic) {
				target.removeChild(graphic);
				_graphicBlock.anchor = null;
			}
			
			super.target = value;
			var targetBlock:Block = Layout.getLayout(target) as Block;
			if (targetBlock != null) {
				targetBlock.defaultWidth = _graphicBlock.defaultWidth;
				targetBlock.defaultHeight = _graphicBlock.defaultHeight;
			}
			
			if (target != null && target != graphic) {
				target.addChild(graphic);
				_graphicBlock.anchor = 0;
			}
		}
		
		public function get graphic():Sprite
		{
			return _graphic;
		}
		
		public function get graphicBlock():Block
		{
			return _graphicBlock;
		}
		
		override public function getSkinPart(part:String):InteractiveObject
		{
			return (part in graphic) ? graphic[part] : (part in target) ? target[part] : null;
		}
		
		private function onStateChange(event:PropertyEvent):void
		{
			MovieClip(_graphic).gotoAndPlay(state);
		}
	}
}