package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Dock extends Layout
	{
		public static const NONE:String = "none";
		public static const LEFT:String = "left";
		public static const TOP:String = "top";
		public static const RIGHT:String = "right";
		public static const BOTTOM:String = "bottom";
		public static const FILL:String = "fill";
		
		
		public function Dock(target:DisplayObjectContainer = null)
		{
			super(target);
		}
		
		override public function layout():void
		{
			super.layout();
			
			if (!_target) return;
			
			var i:int = 0;
			var max:int = _target.numChildren;
			var block:Block = Block.blockIndex[_target];
			
			var dockArea:Rectangle = new Rectangle(0, 0, block.width, block.height);
			var dockMargin:Rectangle = new Rectangle();
			var tileArea:Rectangle;
			var tileMargin:Rectangle;
			var pad:Point = new Point();
			var child:DisplayObject;
			var childBlock:Block;
			
			for ( ; i < max; i++) {
				child = _target.getChildAt(i);
				childBlock = Block.blockIndex[child];
				
				trace('>', child, childBlock);
				if (!childBlock || !child.visible) continue;
				
				// docking
				
				// tiling
				
				// anchoring
			}
		}
	}
}