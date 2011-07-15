package reflex.layouts
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	
	[LayoutProperty(name="x", measure="true")]
	[LayoutProperty(name="y", measure="true")]
	[LayoutProperty(name="width", measure="true")]
	[LayoutProperty(name="height", measure="true")]
	
	/**
	 * Provides basic measurement for containers which want to adjust children manually using x/y coordinates.
	 * 
	 * @alpha
	 **/
	public class XYLayout extends Layout implements ILayout
	{
		
		
		override public function measure(children:Array):Point
		{
			var point:Point = super.measure(children);
			for each(var item:Object in children) {
				var xp:Number = item.x + resolveWidth(item);
				var yp:Number = item.y + resolveHeight(item);
				point.x = Math.max(point.x, xp);
				point.y = Math.max(point.y, yp);
			}
			return point;
		}
		
		override public function update(children:Array, rectangle:Rectangle):void
		{
			super.update(children, rectangle);
		}
		
	}
}