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
	//import reflex.layout.ILayoutAlgorithm;
	import reflex.layout.LayoutWrapper;
	

	public class GraphicSkin extends Skin
	{
		private var _statefulChildren:Array = [];
		private var _graphic:Sprite;
		private var _graphicBlock:Block;
		
		public function GraphicSkin(graphic:Sprite)
		{
			// initialize graphic with smart layout
			_graphic = graphic;
			_graphicBlock = new Block(graphic);
			// TODO: set that layout's scaling if the graphic has no children (slice-9)
			
			// override default width/height if a guide is present
			if ("defaultSize" in graphic && graphic["defaultSize"] is DisplayObject) {
				var defaultSize:DisplayObject = graphic["defaultSize"] as DisplayObject;
				_graphicBlock.defaultWidth = defaultSize.width;
				_graphicBlock.defaultHeight = defaultSize.height;
			}
			
			// TODO: resolve API .. addstatefulchild, etc
			if (_graphic is MovieClip) {
				Bind.addListener(this, gotoState, this, "state");
				addStatefulChild(_graphic as MovieClip);
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
			var targetBlock:Block = LayoutWrapper.getLayout(target) as Block;
			if (targetBlock != null) {
				targetBlock.defaultWidth = _graphicBlock.defaultWidth;
				targetBlock.defaultHeight = _graphicBlock.defaultHeight;
			}
			
			if (target != null && target != graphic) {
				target.addChild(graphic);
				_graphicBlock.anchor = 0;
			}
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
		
		protected function gotoState(state:String):void
		{
			for each (var child:MovieClip in _statefulChildren) {
				child.gotoAndStop(state);
			}
		}
	}
}