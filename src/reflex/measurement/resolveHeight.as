package reflex.measurement
{
	import reflex.display.ReflexDisplay;
	
	/**
	 * @alpha
	 */
	public function resolveHeight(object:Object):Number
	{
		var measurements:IMeasurements;
		if(object is IMeasurable) {
			measurements = (object as IMeasurable).measurements;
			return isNaN(measurements.expliciteHeight) ? measurements.measuredHeight : measurements.expliciteHeight;
		} else if(object is IMeasurements) {
			measurements = (object as IMeasurements);
			return isNaN(measurements.expliciteHeight) ? measurements.measuredHeight : measurements.expliciteHeight;
		} else {
			return (object!=null) ? object.height : NaN;
		}
		
	}
	
}