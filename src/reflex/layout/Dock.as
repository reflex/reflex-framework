package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
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
			var dockArea:Rectangle = new Rectangle(0, 0, block.width, block.height);
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
					updateAnchor(display, child, block);
					continue;
				}
				
				if (child.tile == NONE) {
					dockChild(display, child, child.dock, dockArea, dockMargin.clone().merge(child.margin), hPad, vPad);
					updateArea(display, child, child.dock, dockArea, dockMargin, hPad, vPad);
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
					
					dockChild(display, child, child.tile, tileArea, margin, hPad, vPad);
					updateArea(display, child, child.tile, tileArea, tileMargin, hPad, vPad);
					updateArea(display, child, child.dock, dockArea, dockMargin, hPad, vPad);
				}
				
				lastDock = child.dock;
				
			}
		}
		
		private function updateArea(display:DisplayObject, child:Block, dock:String, area:Rectangle, margin:Box, hPad:Number, vPad:Number):void
		{
			var pos:Number;
			switch (dock) {
				case LEFT :
					if (area.left < (pos = display.x + child.width + hPad) ) {
						area.left = pos;
						margin.left = child.margin.right;
					}
					break;
				case TOP :
					if (area.top < (pos = display.y + child.height + vPad) ) {
						area.top = pos;
						margin.top = child.margin.bottom;
					}
					break;
				case RIGHT :
					if (area.right > (pos = display.x - hPad) ) {
						area.right = pos;
						margin.right = child.margin.left;
					}
					break;
				case BOTTOM :
					if (area.bottom > (pos = display.y - vPad) ) {
						area.bottom = pos;
						margin.bottom = child.margin.top;
					}
					break;
			}
		}
		
		/**
		 * 
		 */
		private function dockChild(display:DisplayObject, child:Block, dock:String, area:Rectangle, margin:Box, hPad:Number, vPad:Number):void
		{
			switch (dock) {
				case LEFT :
					display.x = area.x + margin.left;
					display.y = area.y + margin.top;
					if (child.tile == NONE) {
						child.height = area.height - margin.top - margin.bottom;
					} else if (child.dock == BOTTOM) {
						display.y = area.y + area.height - child.height - margin.bottom;
					}
					break;
				case TOP :
					display.x = area.x + margin.left;
					display.y = area.y + margin.top;
					if (child.tile == NONE) {
						child.width = area.width - margin.left - margin.right;
					} else if (child.dock == RIGHT) {
						display.x = area.x + area.width - child.width - margin.right;
					}
					break;
				case RIGHT :
					display.x = area.x + area.width - child.width - margin.right;
					display.y = area.y + margin.top;
					if (child.tile == NONE) {
						child.height = area.height - margin.top - margin.bottom;
					} else if (child.dock == BOTTOM) {
						display.y = area.y + area.height - child.height - margin.bottom;
					}
					break;
				case BOTTOM :
					display.x = area.x + margin.left;
					display.y = area.y + area.height - child.height - margin.bottom;
					if (child.tile == NONE) {
						child.width = area.width - margin.left - margin.right;
					} else if (child.dock == RIGHT) {
						display.x = area.x + area.width - child.width - margin.right;
					}
					break;
				case FILL :
					display.x = area.x + margin.left;
					display.y = area.y + margin.top;
					if (child.tile == NONE) {
						child.height = area.height - margin.top - margin.bottom;
						child.width = area.width - margin.left - margin.right;
					}
					break;
			}
		}
		
		public function measure(target:DisplayObjectContainer):void
		{
			var block:Block = Layout.getLayout(target) as Block;
			if (block == null) {
				return;
			}
			
			var measurement:Bounds = new Bounds();
			var staticWidth:Number = block.padding.left + block.padding.right;
			var staticHeight:Number = block.padding.top + block.padding.bottom;
			var variable:Number;
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
				if (child == null || child.freeform || child.dock == NONE) {
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
							variable = margin.top;
						} else {
							tileMargin.bottom = child.margin.top;
							variable = margin.bottom;
						}
						tileHeight += child.height + variable + vPad;
						variable = child.width + (child.dock == LEFT ? margin.left : margin.right) + hPad;
						tileWidth = tileWidth >= variable ? tileWidth : variable;
						measurement.minWidth = measurement.constrainWidth(staticWidth + tileWidth);
						measurement.minHeight = measurement.constrainHeight(staticHeight + tileHeight);
					} else {
						if (child.dock == LEFT) {
							dockMargin.left = child.margin.right;
							variable = margin.left;
						} else {
							dockMargin.right = child.margin.left;
							variable = margin.right;
						}
						staticWidth += child.width + variable + hPad;
						variable = staticHeight + margin.top + margin.bottom;
						measurement.minWidth = measurement.constrainWidth(staticWidth);
						measurement.minHeight = measurement.constrainHeight(variable + child.measuredBounds.minHeight);
						measurement.maxHeight = measurement.constrainHeight(variable + child.measuredBounds.maxHeight);
					}
				} else if (child.dock == TOP || child.dock == BOTTOM) {
					if (child.tile != NONE) {
						if (child.dock == LEFT) {
							tileMargin.left = child.margin.right;
							variable = margin.left;
						} else {
							tileMargin.right = child.margin.left;
							variable = margin.right;
						}
						tileWidth += child.width + variable + hPad;
						variable = child.height + (child.dock == TOP ? margin.top : margin.bottom) + vPad;
						tileHeight = tileHeight >= variable ? tileHeight : variable;
						measurement.minWidth = measurement.constrainWidth(staticWidth + tileWidth);
						measurement.minHeight = measurement.constrainHeight(staticHeight + tileHeight);
					} else {
						if (child.dock == TOP) {
							dockMargin.top = child.margin.bottom;
							variable = margin.top;
						} else {
							dockMargin.bottom = child.margin.top;
							variable = margin.bottom;
						}
						staticHeight += child.height + variable + vPad;
						variable = staticWidth + margin.left + margin.right;
						measurement.minHeight = measurement.constrainHeight(staticHeight);
						measurement.minWidth = measurement.constrainWidth(variable + child.measuredBounds.minWidth);
						measurement.maxWidth = measurement.constrainWidth(variable + child.measuredBounds.maxWidth);
					}
				} else {	// if (child.dock == FILL) {
					variable = staticWidth + margin.left + margin.right;
					measurement.minWidth = measurement.constrainWidth(variable + child.measuredBounds.minWidth);
					measurement.maxWidth = measurement.constrainWidth(variable + child.measuredBounds.maxWidth);
					
					variable = staticHeight + margin.top + margin.bottom;
					measurement.minHeight = measurement.constrainHeight(variable + child.measuredBounds.minHeight);
					measurement.maxHeight = measurement.constrainHeight(variable + child.measuredBounds.maxHeight);
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
			
			block.updateMeasurement(measurement);
		}
		
		private function updateAnchor(target:DisplayObject, block:Block, parent:Block):void
		{
			var anchor:Box = block.anchor;
			if ( !isNaN(anchor.left) ) {
				if ( !isNaN(anchor.right) ) {
					block.width = parent.width - anchor.left - anchor.right;
				} else if (anchor.horizontal != 0) {
					block.width = (anchor.horizontal * parent.width) - anchor.left + anchor.offsetX;
				}
				
				target.x = anchor.left;
			} else if ( !isNaN(anchor.right) ) {
				if (anchor.horizontal != 0) {
					block.width = (anchor.horizontal * parent.width) - anchor.right + anchor.offsetX;
				}
				
				target.x = parent.width - block.width - anchor.right;
			} else {
				target.x = anchor.horizontal * (parent.width - block.width) + anchor.offsetX;
			}
			
			if ( !isNaN(anchor.top) ) {
				if ( !isNaN(anchor.bottom) ) {
					block.height = parent.height - anchor.top - anchor.bottom;
				} else if (anchor.vertical != 0) {
					block.height = (anchor.vertical * parent.height) - anchor.top + anchor.offsetY;
				}
				
				target.y = anchor.top;
			} else if ( !isNaN(anchor.bottom) ) {
				if (anchor.vertical != 0) {
					block.height = (anchor.vertical * parent.height) - anchor.bottom + anchor.offsetY;
				}
				
				target.y = parent.height - block.height - anchor.bottom;
			} else {
				target.y = anchor.vertical * (parent.height - block.height) + anchor.offsetY;
			}
		}
		
	}
}
