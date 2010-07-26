package reflex.measurement
{
	
	/**
	 * @alpha
	 */
	public function resolveWidth(object:Object):Number
	{
		var explicite:IMeasurements;
		var measured:IMeasurements;
		if(object is IMeasurable) {
			explicite = (object as IMeasurable).explicite;
			measured = (object as IMeasurable).measured;
			return isNaN(explicite.width) ? measured.width : explicite.width;
		} /* else if(object is IMeasurements) {
			measurements = (object as IMeasurements);
			return isNaN(measurements.expliciteWidth) ? measurements.measuredWidth : measurements.expliciteWidth;
		} */ else {
			return object.width;
		}
		
	}
	
}