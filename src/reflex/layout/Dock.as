package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	public class Dock implements ILayoutAlgorithm
	{
		public function layout(target:DisplayObjectContainer):void
		{
			var block:Block = LayoutWrapper.getLayout(target) as Block;
			if (block == null) {
				return;
			}
			
			var dockMargin:Box = new Box();
			var dockArea:Rectangle = new Rectangle(0, 0, block.displayWidth, block.displayHeight);
			dockArea.left += block.padding.left;
			dockArea.top += block.padding.top;
			dockArea.right -= block.padding.right;
			dockArea.bottom -= block.padding.bottom;
			
			var alignMargin:Box;
			var alignArea:Rectangle;
			var margin:Box;
			
			var hPad:Number = block.padding.horizontal;
			var vPad:Number = block.padding.vertical;
			var lastDock:String = Align.NONE;
			
			for (var i:int = 0; i < target.numChildren; i++) {
				var display:DisplayObject = target.getChildAt(i);
				var child:Block = LayoutWrapper.getLayout(display) as Block;
				if (child == null || child.freeform) {
					continue;
				}
				
				if (child.dock == Align.NONE) {
					updateAnchor(child, block);
					continue;
				}
				
				if (child.align == Align.NONE) {
					dockChild(child, child.dock, dockArea, dockMargin.clone().merge(child.margin));
					updateArea(child, child.dock, dockArea, dockMargin, hPad, vPad);
					alignMargin = null;				// TODO: reuse rectangle/box objects (cache)
				} else {
					
					if (alignMargin == null || child.dock != lastDock) {
						alignMargin = dockMargin.clone();
						alignArea = dockArea.clone();
						margin = alignMargin.clone().merge(child.margin);
					} else if (true) {	// TODO: wrapping aligned items disabled - either enable or remove
						
						// reset tiling if child doesn't fit inline
						margin = alignMargin.clone().merge(child.margin);
						if (child.align == Align.LEFT || child.align == Align.RIGHT) {
							if (alignArea.width < child.width + margin.left + margin.right) {
								alignMargin = dockMargin.clone();
								alignArea = dockArea.clone();
								margin = alignMargin.clone().merge(child.margin);
							}
						}
						
						if (child.align == Align.TOP || child.align == Align.BOTTOM) {
							if (alignArea.height < child.height + margin.top + margin.bottom) {
								alignMargin = dockMargin.clone();
								alignArea = dockArea.clone();
								margin = alignMargin.clone().merge(child.margin);
							}
						}
					}
					
					dockChild(child, child.align, alignArea, margin);
					updateArea(child, child.align, alignArea, alignMargin, hPad, vPad);
					updateArea(child, child.dock, dockArea, dockMargin, hPad, vPad);
				}
				
				lastDock = child.dock;
				
			}
		}
		
		private function updateArea(child:Block, dock:String, area:Rectangle, margin:Box, hPad:Number, vPad:Number):void
		{
			var pos:Number;
			switch (dock) {
				case Align.LEFT :
					if (area.left < (pos = child.x + child.width + hPad) ) {
						area.left = pos;
					}
					margin.left = child.margin.right;
					break;
				case Align.TOP :
					if (area.top < (pos = child.y + child.height + vPad) ) {
						area.top = pos;
					}
					margin.top = child.margin.bottom;
					break;
				case Align.RIGHT :
					if (area.right > (pos = child.x - hPad) ) {
						area.right = pos;
					}
					margin.right = child.margin.left;
					break;
				case Align.BOTTOM :
					if (area.bottom > (pos = child.y - vPad) ) {
						area.bottom = pos;
					}
					margin.bottom = child.margin.top;
					break;
			}
		}
		
		/**
		 * 
		 */
		private function dockChild(child:Block, dock:String, area:Rectangle, margin:Box):void
		{
			switch (dock) {
				case Align.LEFT :
					child.x = area.x + margin.left;
					child.y = area.y + margin.top;
					if (child.align == Align.NONE) {
						child.height = area.height - margin.top - margin.bottom;
					} else if (child.dock == Align.BOTTOM) {
						child.y = area.y + area.height - child.height - margin.bottom;
					}
					break;
				case Align.TOP :
					child.x = area.x + margin.left;
					child.y = area.y + margin.top;
					if (child.align == Align.NONE) {
						child.width = area.width - margin.left - margin.right;
					} else if (child.dock == Align.RIGHT) {
						child.x = area.x + area.width - child.width - margin.right;
					}
					break;
				case Align.RIGHT :
					child.x = area.x + area.width - child.width - margin.right;
					child.y = area.y + margin.top;
					if (child.align == Align.NONE) {
						child.height = area.height - margin.top - margin.bottom;
					} else if (child.dock == Align.BOTTOM) {
						child.y = area.y + area.height - child.height - margin.bottom;
					}
					break;
				case Align.BOTTOM :
					child.x = area.x + margin.left;
					child.y = area.y + area.height - child.height - margin.bottom;
					if (child.align == Align.NONE) {
						child.width = area.width - margin.left - margin.right;
					} else if (child.dock == Align.RIGHT) {
						child.x = area.x + area.width - child.width - margin.right;
					}
					break;
				case Align.FILL :
					child.x = area.x + margin.left;
					child.y = area.y + margin.top;
					if (child.align == Align.NONE) {
						child.height = area.height - margin.top - margin.bottom;
						child.width = area.width - margin.left - margin.right;
					}
					break;
				case Align.CENTER :
					child.x = area.width/2 - child.width/2;
					child.y = area.height/2 - child.height/2;
					break;
			}
		}
		
		// TODO: factor anchor into the measurement
		public function measure(target:DisplayObjectContainer):void
		{
			var block:Block = LayoutWrapper.getLayout(target) as Block;
			if (block == null) {
				return;
			}
			
			var measurement:Bounds = new Bounds();
			var anchored:Bounds = new Bounds();
			var staticWidth:Number = block.padding.left + block.padding.right;
			var staticHeight:Number = block.padding.top + block.padding.bottom;
			var space:Number;
			var alignWidth:Number;
			var alignHeight:Number;
			
			var dockMargin:Box = new Box();
			var alignMargin:Box;
			var margin:Box;
			
			var hPad:Number = block.padding.horizontal;
			var vPad:Number = block.padding.vertical;
			var lastDock:String = Align.NONE;
			
			for (var i:int = 0; i < target.numChildren; i++) {
				var display:DisplayObject = target.getChildAt(i);
				var child:Block = LayoutWrapper.getLayout(display) as Block;
				if (child == null || child.freeform) {
					continue;
				}
				
				if (child.dock == Align.NONE) {
					measureAnchored(child, anchored);
					continue;
				}
				
				if (child.align == Align.NONE) {
					if (alignMargin != null) {
						if (lastDock == Align.LEFT || lastDock == Align.RIGHT) {
							staticWidth += alignWidth;
							measurement.minHeight += -vPad;	// TODO: no check for top vs bottom & assumption that minHeight was effected by align
						} else {
							staticHeight += alignHeight;
							measurement.minWidth += -hPad;	// TODO: no check for left vs right & assumption that minHeight was effected by align
						}
						alignMargin = null;
					}
					margin = dockMargin.clone().merge(child.margin);
				} else {
					
					if (alignMargin == null || child.dock != lastDock) {
						alignMargin = dockMargin.clone();
						margin = alignMargin.clone().merge(child.margin);
						alignWidth = 0;
						alignHeight = 0;
					}
					
					margin = alignMargin.clone().merge(child.margin);
				}
				
				if (child.dock == Align.LEFT || child.dock == Align.RIGHT) {
					if (child.align != Align.NONE) {
						if (child.align == Align.TOP) {
							alignMargin.top = child.margin.bottom;
							space = margin.top;
						} else {
							alignMargin.bottom = child.margin.top;
							space = margin.bottom;
						}
						alignHeight += child.height + space + vPad;
						space = child.width + (child.dock == Align.LEFT ? margin.left : margin.right) + hPad;
						alignWidth = alignWidth >= space ? alignWidth : space;
						measurement.minWidth = measurement.constrainWidth(staticWidth + alignWidth);
						measurement.minHeight = measurement.constrainHeight(staticHeight + alignHeight);
					} else {
						if (child.dock == Align.LEFT) {
							dockMargin.left = child.margin.right;
							space = margin.left;
						} else {
							dockMargin.right = child.margin.left;
							space = margin.right;
						}
						staticWidth += child.width + space + hPad;
						space = staticHeight + margin.top + margin.bottom;
						measurement.minWidth = measurement.constrainWidth(staticWidth);
						measurement.minHeight = measurement.constrainHeight(space + child.blockBounds.minHeight);
						measurement.maxHeight = measurement.constrainHeight(space + child.blockBounds.maxHeight);
					}
				} else if (child.dock == Align.TOP || child.dock == Align.BOTTOM) {
					if (child.align != Align.NONE) {
						if (child.dock == Align.LEFT) {
							alignMargin.left = child.margin.right;
							space = margin.left;
						} else {
							alignMargin.right = child.margin.left;
							space = margin.right;
						}
						alignWidth += child.width + space + hPad;
						space = child.height + (child.dock == Align.TOP ? margin.top : margin.bottom) + vPad;
						alignHeight = alignHeight >= space ? alignHeight : space;
						measurement.minWidth = measurement.constrainWidth(staticWidth + alignWidth);
						measurement.minHeight = measurement.constrainHeight(staticHeight + alignHeight);
					} else {
						if (child.dock == Align.TOP) {
							dockMargin.top = child.margin.bottom;
							space = margin.top;
						} else {
							dockMargin.bottom = child.margin.top;
							space = margin.bottom;
						}
						staticHeight += child.height + space + vPad;
						space = staticWidth + margin.left + margin.right;
						measurement.minHeight = measurement.constrainHeight(staticHeight);
						measurement.minWidth = measurement.constrainWidth(space + child.blockBounds.minWidth);
						measurement.maxWidth = measurement.constrainWidth(space + child.blockBounds.maxWidth);
					}
				} else {	// if (child.dock == FILL) {
					space = staticWidth + margin.left + margin.right;
					measurement.minWidth = measurement.constrainWidth(space + child.blockBounds.minWidth);
					measurement.maxWidth = measurement.constrainWidth(space + child.blockBounds.maxWidth);
					
					space = staticHeight + margin.top + margin.bottom;
					measurement.minHeight = measurement.constrainHeight(space + child.blockBounds.minHeight);
					measurement.maxHeight = measurement.constrainHeight(space + child.blockBounds.maxHeight);
				}
				
				lastDock = child.dock;
			}
			
			// remove the last pad and add the last margin
			switch (lastDock) {
				case Align.LEFT : measurement.minWidth += margin.right - hPad; break;
				case Align.TOP : measurement.minHeight += margin.bottom - vPad; break;
				case Align.RIGHT : measurement.minWidth += margin.left - hPad; break;
				case Align.BOTTOM : measurement.minHeight += margin.top - vPad; break;
			}
			
			measurement.merge(anchored);
			block.updateMeasurement(measurement);
		}
		
		private function measureAnchored(block:Block, measurement:Bounds):void
		{
			var space:Number;
			if ( !isNaN(block.anchor.left) ) {
				if ( !isNaN(block.anchor.right) ) {
					space = block.anchor.left + block.anchor.right;
					measurement.minWidth = measurement.constrainWidth(space + block.blockBounds.minWidth);
					measurement.maxWidth = measurement.constrainWidth(space + block.blockBounds.maxWidth);
				} else if ( !isNaN(block.anchor.horizontal) ) {
					space = block.anchor.left - block.anchor.offsetX;
					measurement.minWidth = measurement.constrainWidth(space + block.blockBounds.minWidth/block.anchor.horizontal);
					measurement.maxWidth = measurement.constrainWidth(space + block.blockBounds.maxWidth/block.anchor.horizontal);
				} else {
					space = block.anchor.left;
					measurement.minWidth = measurement.constrainWidth(space + block.width);
				}
			} else if ( !isNaN(block.anchor.right) ) {
				if ( !isNaN(block.anchor.horizontal) ) {
					space = block.anchor.right + block.anchor.offsetX;
					measurement.minWidth = measurement.constrainWidth(space + block.blockBounds.minWidth/block.anchor.horizontal);
					measurement.maxWidth = measurement.constrainWidth(space + block.blockBounds.maxWidth/block.anchor.horizontal);
				} else {
					space = block.anchor.right;
					measurement.minWidth = measurement.constrainWidth(space + block.width);
				}
			} else if ( !isNaN(block.anchor.horizontal) ) {
				measurement.minWidth = measurement.constrainWidth(Math.abs(block.anchor.offsetX) + block.width);
			}
			
			if ( !isNaN(block.anchor.top) ) {
				if ( !isNaN(block.anchor.bottom) ) {
					space = block.anchor.top + block.anchor.bottom;
					measurement.minHeight = measurement.constrainHeight(space + block.blockBounds.minHeight);
					measurement.maxHeight = measurement.constrainHeight(space + block.blockBounds.maxHeight);
				} else if ( !isNaN(block.anchor.vertical) ) {
					space = block.anchor.top - block.anchor.offsetY;
					measurement.minHeight = measurement.constrainHeight(space + block.blockBounds.minHeight/block.anchor.vertical);
					measurement.maxHeight = measurement.constrainHeight(space + block.blockBounds.maxHeight/block.anchor.vertical);
				} else {
					space = block.anchor.top;
					measurement.minHeight = measurement.constrainHeight(space + block.height);
				}
			} else if ( !isNaN(block.anchor.bottom) ) {
				if ( !isNaN(block.anchor.vertical) ) {
					space = block.anchor.bottom + block.anchor.offsetY;
					measurement.minHeight = measurement.constrainHeight(space + block.blockBounds.minHeight/block.anchor.vertical);
					measurement.maxHeight = measurement.constrainHeight(space + block.blockBounds.maxHeight/block.anchor.vertical);
				} else {
					space = block.anchor.bottom;
					measurement.minHeight = measurement.constrainHeight(space + block.height);
				}
			} else if ( !isNaN(block.anchor.vertical) ) {
				measurement.minHeight = measurement.constrainHeight(Math.abs(block.anchor.offsetY) + block.height);
			}
		}
		
		private function updateAnchor(block:Block, parent:Block):void
		{
			var anchor:Box = block.anchor;
			if ( !isNaN(anchor.left) ) {
				if ( !isNaN(anchor.right) ) {
					block.width = parent.displayWidth - anchor.left - anchor.right;
				} else if ( !isNaN(anchor.horizontal) ) {
					block.width = (anchor.horizontal * parent.displayWidth) - anchor.left + anchor.offsetX;
				}
				
				block.x = anchor.left;
			} else if ( !isNaN(anchor.right) ) {
				if ( !isNaN(anchor.horizontal) ) {
					block.width = (anchor.horizontal * parent.displayWidth) - anchor.right + anchor.offsetX;
				}
				
				block.x = parent.displayWidth - block.width - anchor.right;
			} else if ( !isNaN(anchor.horizontal) ) {
				block.x = anchor.horizontal * (parent.displayWidth - block.width) + anchor.offsetX;
			}
			
			if ( !isNaN(anchor.top) ) {
				if ( !isNaN(anchor.bottom) ) {
					block.height = parent.displayHeight - anchor.top - anchor.bottom;
				} else if ( !isNaN(anchor.vertical) ) {
					block.height = (anchor.vertical * parent.displayHeight) - anchor.top + anchor.offsetY;
				}
				
				block.y = anchor.top;
			} else if ( !isNaN(anchor.bottom) ) {
				if ( !isNaN(anchor.vertical) ) {
					block.height = (anchor.vertical * parent.displayHeight) - anchor.bottom + anchor.offsetY;
				}
				
				block.y = parent.displayHeight - block.height - anchor.bottom;
			} else if ( !isNaN(anchor.vertical) ) {
				block.y = anchor.vertical * (parent.displayHeight - block.height) + anchor.offsetY;
			}
		}
		
	}
}
