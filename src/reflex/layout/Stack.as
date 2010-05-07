package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	public class Stack implements ILayoutAlgorithm
	{
		// TODO: implement horizontal, 'tsall vert right now
		public var horizontal:Boolean;
		
		public function measure(target:DisplayObjectContainer):void
		{
			var block:Block = LayoutWrapper.getLayout(target) as Block;
			if (block == null) {
				return;
			}
			
			var measurement:Bounds = new Bounds();
			var staticWidth:Number = block.padding.left + block.padding.right;
			var staticHeight:Number = block.padding.top + block.padding.bottom;
			
			var stackMargin:Box = new Box();
			var margin:Box;
			var hPad:Number = block.padding.horizontal;
			var vPad:Number = block.padding.vertical;
			
			for (var i:int = 0; i < target.numChildren; i++) {
				var display:DisplayObject = target.getChildAt(i);
				var child:Block = LayoutWrapper.getLayout(display) as Block;
				if (child == null || child.freeform) {
					continue;
				}
				
				margin = stackMargin.clone().merge(child.margin);
				
				
				stackMargin.top = child.margin.bottom;
				
				var space:Number = margin.left + margin.right;
				staticHeight += child.height + margin.top + vPad;
				measurement.minHeight = measurement.constrainHeight(staticHeight);
				measurement.minWidth = measurement.constrainWidth(space + child.blockBounds.minWidth);
				measurement.maxWidth = measurement.constrainWidth(space + child.blockBounds.maxWidth);
			}
			
			if (margin != null) {
				measurement.minWidth += margin.bottom - hPad;
			}
			block.updateMeasurement(measurement);
		}
		
		public function layout(target:DisplayObjectContainer):void
		{
			var block:Block = LayoutWrapper.getLayout(target) as Block;
			if (block == null) {
				return;
			}
			
			var stackMargin:Box = new Box();
			var stackArea:Rectangle = new Rectangle(0, 0, block.displayWidth, block.displayHeight);
			stackArea.left += block.padding.left;
			stackArea.top += block.padding.top;
			stackArea.right -= block.padding.right;
			stackArea.bottom -= block.padding.bottom;
			
			var margin:Box;
			var pos:Number;
			
			var hPad:Number = block.padding.horizontal;
			var vPad:Number = block.padding.vertical;
			var lastDock:String = Align.NONE;
			
			for (var i:int = 0; i < target.numChildren; i++) {
				var display:DisplayObject = target.getChildAt(i);
				var child:Block = LayoutWrapper.getLayout(display) as Block;
				if (child == null || child.freeform) {
					continue;
				}
				
				margin = stackMargin.clone().merge(child.margin);
				
				child.x = stackArea.x + margin.left;
				child.y = stackArea.y + margin.top;
				// TODO: implement alignment, not always stretch (fill)
				child.width = stackArea.width - margin.left - margin.right;
				if (stackArea.top < (pos = child.y + child.height + vPad) ) {
					stackArea.top = pos;
					stackMargin.top = child.margin.bottom;
				}
				child.y -= block.shift;
			}
		}
		
		
	}
}