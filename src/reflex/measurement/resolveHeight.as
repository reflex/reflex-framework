package reflex.measurement
{
	
	/**
	 * @alpha
	 */
	public function resolveHeight(object:Object):Number
	{
		var explicite:IMeasurements;
		var measured:IMeasurements;
		if(object is IMeasurable) {
			explicite = (object as IMeasurable).explicite;
			measured = (object as IMeasurable).measured;
			return isNaN(explicite.height) ? measured.height : explicite.height;
		} /*else if(object is IMeasurements) {
			explicite = (object as IMeasurable).explicite;
			measured = (object as IMeasurable).measured;
			return isNaN(explicite.height) ? measured.height : explicite.height;
		} */ else {
			return object.height;
		}
		
	}
	
}