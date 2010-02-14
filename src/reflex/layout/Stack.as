package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	public class Stack implements ILayoutAlgorithm
	{
		public function measure(target:DisplayObjectContainer):void
		{
			
		}
		
		public function layout(target:DisplayObjectContainer):void
		{
			var block:Block = Layout.getLayout(target) as Block;
			if (block == null) {
				return;
			}
			
			var stackArea:Rectangle = new Rectangle(0, 0, block.displayWidth, block.displayHeight);
			stackArea.left += block.padding.left;
			stackArea.top += block.padding.top;
			stackArea.right -= block.padding.right;
			stackArea.bottom -= block.padding.bottom;
			
			var tileMargin:Box;
			var tileArea:Rectangle;
			var margin:Box;
			
			var hPad:Number = block.padding.horizontal;
			var vPad:Number = block.padding.vertical;
			var lastDock:String = Align.NONE;
			
			for (var i:int = 0; i < target.numChildren; i++) {
				var display:DisplayObject = target.getChildAt(i);
				var child:Block = Layout.getLayout(display) as Block;
				if (child == null || child.freeform) {
					continue;
				}
			}
		}
		
	}
}