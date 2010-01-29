package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	public class Dock implements ILayoutAlgorithm
	{
		public static const NONE:String = "none";
		public static const LEFT:String = "left";
		public static const TOP:String = "top";
		public static const RIGHT:String = "right";
		public static const BOTTOM:String = "bottom";
		public static const FILL:String = "fill";
		
		public function layout(target:DisplayObjectContainer):void
		{
			var block:Block = Layout.getLayout(target) as Block;
			if (block == null) {
				return;
			}
			
			var dockMargin:Box = new Box();
			var dockArea:Rectangle = new Rectangle(0, 0, block.displayWidth, block.displayHeight);
			dockArea.left += block.padding.left;
			dockArea.top += block.padding.top;
			dockArea.right -= block.padding.right;
			dockArea.bottom -= block.padding.bottom;
			
			var tileMargin:Box;
			var tileArea:Rectangle;
			var margin:Box;
			
			var hPad:Number = block.padding.horizontal;
			var vPad:Number = block.padding.vertical;
			var lastDock:String = NONE;
			
			for (var i:int = 0; i < target.numChildren; i++) {
				var display:DisplayObject = target.getChildAt(i);
				var child:Block = Layout.getLayout(display) as Block;
				if (child == null || child.freeform) {
					continue;
				}
				
				if (child.dock == NONE) {
					updateAnchor(child, block);
					continue;
				}
				
				if (child.tile == NONE) {
					dockChild(child, child.dock, dockArea, dockMargin.clone().merge(child.margin), hPad, vPad);
					updateArea(child, child.dock, dockArea, dockMargin, hPad, vPad);
					tileMargin = null;				// TODO: reuse rectangle/box objects (cache)
				} else {
					
					if (tileMargin == null || child.dock != lastDock) {
						tileMargin = dockMargin.clone();
						tileArea = dockArea.clone();
						margin = tileMargin.clone().merge(child.margin);
					} else if (true) {	// TODO: wrapping tiled items disabled - either enable or remove
						
						// reset tiling if child doesn't fit inline
						margin = tileMargin.clone().merge(child.margin);
						if (child.tile == LEFT || child.tile == RIGHT) {
							if (tileArea.width < child.width + margin.left + margin.right) {
								tileMargin = dockMargin.clone();
								tileArea = dockArea.clone();
								margin = tileMargin.clone().merge(child.margin);
							}
						}
						
						if (child.tile == TOP || child.tile == BOTTOM) {
							if (tileArea.height < child.height + margin.top + margin.bottom) {
								tileMargin = dockMargin.clone();
								tileArea = dockArea.clone();
								margin = tileMargin.clone().merge(child.margin);
							}
						}
					}
					
					dockChild(child, child.tile, tileArea, margin, hPad, vPad);
					updateArea(child, child.tile, tileArea, tileMargin, hPad, vPad);
					updateArea(child, child.dock, dockArea, dockMargin, hPad, vPad);
				}
				
				lastDock = child.dock;
				
			}
		}
		
		private function updateArea(child:Block, dock:String, area:Rectangle, margin:Box, hPad:Number, vPad:Number):void
		{
			var pos:Number;
			switch (dock) {
				case LEFT :
					if (area.left < (pos = child.x + child.width + hPad) ) {
						area.left = pos;
						margin.left = child.margin.right;
					}
					break;
				case TOP :
					if (area.top < (pos = child.y + child.height + vPad) ) {
						area.top = pos;
						margin.top = child.margin.bottom;
					}
					break;
				case RIGHT :
					if (area.right > (pos = child.x - hPad) ) {
						area.right = pos;
						margin.right = child.margin.left;
					}
					break;
				case BOTTOM :
					if (area.bottom > (pos = child.y - vPad) ) {
						area.bottom = pos;
						margin.bottom = child.margin.top;
					}
					break;
			}
		}
		
		/**
		 * 
		 */
		private function dockChild(child:Block, dock:String, area:Rectangle, margin:Box, hPad:Number, vPad:Number):void
		{
			switch (dock) {
				case LEFT :
					child.x = area.x + margin.left;
					child.y = area.y + margin.top;
					if (child.tile == NONE) {
						child.height = area.height - margin.top - margin.bottom;
					} else if (child.dock == BOTTOM) {
						child.y = area.y + area.height - child.height - margin.bottom;
					}
					break;
				case TOP :
					child.x = area.x + margin.left;
					child.y = area.y + margin.top;
					if (child.tile == NONE) {
						child.width = area.width - margin.left - margin.right;
					} else if (child.dock == RIGHT) {
						child.x = area.x + area.width - child.width - margin.right;
					}
					break;
				case RIGHT :
					child.x = area.x + area.width - child.width - margin.right;
					child.y = area.y + margin.top;
					if (child.tile == NONE) {
						child.height = area.height - margin.top - margin.bottom;
					} else if (child.dock == BOTTOM) {
						child.y = area.y + area.height - child.height - margin.bottom;
					}
					break;
				case BOTTOM :
					child.x = area.x + margin.left;
					child.y = area.y + area.height - child.height - margin.bottom;
					if (child.tile == NONE) {
						child.width = area.width - margin.left - margin.right;
					} else if (child.dock == RIGHT) {
						child.x = area.x + area.width - child.width - margin.right;
					}
					break;
				case FILL :
					child.x = area.x + margin.left;
					child.y = area.y + margin.top;
					if (child.tile == NONE) {
						child.height = area.height - margin.top - margin.bottom;
						child.width = area.width - margin.left - margin.right;
					}
					break;
			}
		}
		
		// TODO: factor anchor into the measurement
		public function measure(target:DisplayObjectContainer):void
		{
			var block:Block = Layout.getLayout(target) as Block;
			if (block == null) {
				return;
			}
			
			var measurement:Bounds = new Bounds();
			var anchored:Bounds = new Bounds();
			var staticWidth:Number = block.padding.left + block.padding.right;
			var staticHeight:Number = block.padding.top + block.padding.bottom;
			var space:Number;
			var tileWidth:Number;
			var tileHeight:Number;
			
			var dockMargin:Box = new Box();
			var tileMargin:Box;
			var margin:Box;
			
			var hPad:Number = block.padding.horizontal;
			var vPad:Number = block.padding.vertical;
			var lastDock:String = NONE;
			
			for (var i:int = 0; i < target.numChildren; i++) {
				var display:DisplayObject = target.getChildAt(i);
				var child:Block = Layout.getLayout(display) as Block;
				if (child == null || child.freeform) {
					continue;
				}
				
				if (child.dock == NONE) {
					measureAnchored(child, anchored);
					continue;
				}
				
				if (child.tile == NONE) {
					if (tileMargin != null) {
						if (lastDock == LEFT || lastDock == RIGHT) {
							staticWidth += tileWidth;
							measurement.minHeight += -vPad;	// TODO: no check for top vs bottom & assumption that minHeight was effected by tile
						} else {
							staticHeight += tileHeight;
							measurement.minWidth += -hPad;	// TODO: no check for left vs right & assumption that minHeight was effected by tile
						}
						tileMargin = null;
					}
					margin = dockMargin.clone().merge(child.margin);
				} else {
					
					if (tileMargin == null || child.dock != lastDock) {
						tileMargin = dockMargin.clone();
						margin = tileMargin.clone().merge(child.margin);
						tileWidth = 0;
						tileHeight = 0;
					}
					
					margin = tileMargin.clone().merge(child.margin);
				}
				
				if (child.dock == LEFT || child.dock == RIGHT) {
					if (child.tile != NONE) {
						if (child.tile == TOP) {
							tileMargin.top = child.margin.bottom;
							space = margin.top;
						} else {
							tileMargin.bottom = child.margin.top;
							space = margin.bottom;
						}
						tileHeight += child.height + space + vPad;
						space = child.width + (child.dock == LEFT ? margin.left : margin.right) + hPad;
						tileWidth = tileWidth >= space ? tileWidth : space;
						measurement.minWidth = measurement.constrainWidth(staticWidth + tileWidth);
						measurement.minHeight = measurement.constrainHeight(staticHeight + tileHeight);
					} else {
						if (child.dock == LEFT) {
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
				} else if (child.dock == TOP || child.dock == BOTTOM) {
					if (child.tile != NONE) {
						if (child.dock == LEFT) {
							tileMargin.left = child.margin.right;
							space = margin.left;
						} else {
							tileMargin.right = child.margin.left;
							space = margin.right;
						}
						tileWidth += child.width + space + hPad;
						space = child.height + (child.dock == TOP ? margin.top : margin.bottom) + vPad;
						tileHeight = tileHeight >= space ? tileHeight : space;
						measurement.minWidth = measurement.constrainWidth(staticWidth + tileWidth);
						measurement.minHeight = measurement.constrainHeight(staticHeight + tileHeight);
					} else {
						if (child.dock == TOP) {
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
				case LEFT : measurement.minWidth += margin.right - hPad; break;
				case TOP : measurement.minWidth += margin.bottom - hPad; break;
				case RIGHT : measurement.minWidth += margin.left - hPad; break;
				case BOTTOM : measurement.minWidth += margin.top - hPad; break;
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
