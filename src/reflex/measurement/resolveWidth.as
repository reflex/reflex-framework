package reflex.measurement
{
	import reflex.display.ReflexDisplay;
	
	public function resolveWidth(object:Object):Number
	{
		
		// update to interfaces later
		if(object is ReflexDisplay) {
			var measurements:Measurements = (object as ReflexDisplay).measurements;
			return isNaN(measurements.expliciteWidth) ? measurements.measuredWidth : measurements.expliciteWidth;
		} else {
			return object.width;
		}
		
	}
	
}