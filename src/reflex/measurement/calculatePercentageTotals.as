package reflex.measurement
{
	import flash.geom.Point;
	import reflex.framework.IMeasurablePercent;
	
	public function calculatePercentageTotals(children:Array):Point
	{
		var point:Point = new Point(0, 0);
		var length:int = children.length;
		for(var i:int = 0; i < length; i++) {
			var child:Object = children[i];
			if(child is IMeasurablePercent && !isNaN((child as IMeasurablePercent).percentWidth) ) {
				point.x += (child as IMeasurablePercent).percentWidth;
			}
			if(child is IMeasurablePercent && !isNaN((child as IMeasurablePercent).percentHeight) ) {
				point.y += (child as IMeasurablePercent).percentHeight;
			}
		}
		point.x = Math.max(point.x, 100);
		point.y = Math.max(point.y, 100);
		return point;
	}
	
}