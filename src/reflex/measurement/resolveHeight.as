package reflex.measurement
{
	
	/**
	 * @alpha
	 */
	public function resolveHeight(object:Object):Number
	{
		var explicit:IMeasurements;
		var measured:IMeasurements;
		if (object is IMeasurable) {
			explicit = (object as IMeasurable).explicit;
			measured = (object as IMeasurable).measured;
			return isNaN(explicit.height) ? measured.height : explicit.height;
		} /*else if (object is IMeasurements) {
			explicit = (object as IMeasurable).explicit;
			measured = (object as IMeasurable).measured;
			return isNaN(explicit.height) ? measured.height : explicit.height;
		} */ else {
			return object.height;
		}
		
	}
	
}