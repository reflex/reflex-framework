package reflex.measurement
{
	import reflex.display.ReflexDisplay;
	
	public function resolveHeight(object:Object):Number
	{
		
		// update to interfaces later
		if(object is ReflexDisplay) {
			var measurements:Measurements = (object as ReflexDisplay).measurements;
			return isNaN(measurements.expliciteHeight) ? measurements.measuredHeight : measurements.expliciteHeight;
		} else {
			return object.height;
		}
		
	}
	
}