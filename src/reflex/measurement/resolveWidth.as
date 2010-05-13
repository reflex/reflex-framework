package reflex.measurement
{
	import reflex.display.ReflexDisplay;
	
	/**
	 * @alpha
	 */
	public function resolveWidth(object:Object):Number
	{
		var measurements:IMeasurements;
		if(object is IMeasurable) {
			measurements = (object as IMeasurable).measurements;
			return isNaN(measurements.expliciteWidth) ? measurements.measuredWidth : measurements.expliciteWidth;
		} else if(object is IMeasurements) {
			measurements = (object as IMeasurements);
			return isNaN(measurements.expliciteWidth) ? measurements.measuredWidth : measurements.expliciteWidth;
		} else {
			return object.width;
		}
		
	}
	
}