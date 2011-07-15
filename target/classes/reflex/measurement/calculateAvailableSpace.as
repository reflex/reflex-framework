package reflex.measurement
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public function calculateAvailableSpace(children:Array, rectangle:Rectangle):Point
	{
		var point:Point = new Point(rectangle.width, rectangle.height);
		for each(var child:Object in children) {
			if(!(child is IMeasurablePercent) || isNaN((child as IMeasurablePercent).percentWidth)) {
				point.x -= reflex.measurement.resolveWidth(child); // excludes percent-based width
			}
			if(!(child is IMeasurablePercent) || isNaN((child as IMeasurablePercent).percentHeight)) {
				point.y -= reflex.measurement.resolveHeight(child); // excludes percent-based height
			}
		}
		point.x = Math.max(point.x, 0);
		point.y = Math.max(point.y, 0);
		return point;
	}
}