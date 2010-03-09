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
		private var _statefulChildren:Array = [];
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
				Bind.addListener(this, onStateChange, this, "state");
				addStatefulChild(_graphic as MovieClip);
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
			return (part in graphic) ? graphic[part] : (part in this) ? this[part] : (part in target) ? target[part] : null;
		}
		
		public function addStatefulChild(child:MovieClip):void
		{
			if (_statefulChildren.indexOf(child) != -1) return;
			
			_statefulChildren.push(child);
			
			// each label should be for a state.
			var labels:Array = child.currentLabels;
			for each (var label:FrameLabel in labels) {
				child.addFrameScript(label.frame - 1, child.stop);
			}
			child.addFrameScript(child.totalFrames - 1, child.stop);
		}
		
		public function removeStatefulChild(child:MovieClip):void
		{
			var index:int = _statefulChildren.indexOf(child);
			if (index != -1) {
				_statefulChildren.splice(index, 1);
			}
		}
		
		private function onStateChange(oldState:String, state:String):void
		{
			for each (var child:MovieClip in _statefulChildren) {
				child.gotoAndStop(state);
			}
		}
	}
}