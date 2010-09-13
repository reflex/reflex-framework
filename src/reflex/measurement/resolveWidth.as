package reflex.measurement
{
	
	/**
	 * @alpha
	 */
	public function resolveWidth(object:Object):Number
	{
		var explicit:IMeasurements;
		var measured:IMeasurements;
		if (object is IMeasurable) {
			explicit = (object as IMeasurable).explicit;
			measured = (object as IMeasurable).measured;
			return isNaN(explicit.width) ? measured.width : explicit.width;
		} /* else if (object is IMeasurements) {
			measurements = (object as IMeasurements);
			return isNaN(measurements.explicitWidth) ? measurements.measuredWidth : measurements.explicitWidth;
		} */ else {
			return object.width;
		}
		
	}
	
}