package reflex.layouts
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import reflex.measurement.IMeasurablePercent;
	import reflex.measurement.calculateAvailableSpace;
	import reflex.measurement.calculatePercentageTotals;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	import reflex.measurement.setSize;
	
	[LayoutProperty(name="width", measure="true")]
	[LayoutProperty(name="height", measure="true")]
	
	/**
	 * Provides a measured layout from top to bottom.
	 * 
	 * @alpha
	 **/
	public class VerticalLayout extends Layout implements ILayout
	{
		
		
		public var gap:Number = 5;
		
		override public function measure(children:Array):Point
		{
			super.measure(children);
			var point:Point = new Point(0, gap/2);
			for each(var child:Object in children) {
				var width:Number = reflex.measurement.resolveWidth(child);
				var height:Number = reflex.measurement.resolveHeight(child);
				point.x = Math.max(point.x, width);
				point.y += height + gap;
			}
			point.y -= gap/2;
			return point;
		}
		
		override public function update(children:Array, rectangle:Rectangle):void
		{
			super.update(children, rectangle);
			if(children) {
				// this takes a few passes for percent-based measurement. we can probably speed it up later
				var availableSpace:Point = reflex.measurement.calculateAvailableSpace(children, rectangle);
				var percentageTotals:Point = reflex.measurement.calculatePercentageTotals(children);
				
				var position:Number = gap/2;
				var length:int = children.length;
				for(var i:int = 0; i < length; i++) {
					var child:Object = children[i];
					var width:Number = reflex.measurement.resolveWidth(child, rectangle.width); // calculate percentWidths based on full width and with no normalization
					var height:Number = reflex.measurement.resolveHeight(child, availableSpace.y - gap*length, percentageTotals.y);  // calculate percentHeights based on available height and normalized percentages
					reflex.measurement.setSize(child, Math.round(width), Math.round(height));
					child.x = Math.round(rectangle.width/2 - width/2);
					child.y = Math.round(position);
					position += height + gap;
				}
			}
		}
		
	}
}