package reflex.measurement
{
	
	/**
	 * @alpha
	 */
	public function resolveHeight(object:Object, total:Number = NaN, percentageTotal:Number = 100):Number
	{
		//var explicit:IMeasurements;
		//var measured:IMeasurements;
		//var percent:IMeasurablePercent;
		if (object is IMeasurable && (object as IMeasurable).explicit != null && !isNaN((object as IMeasurable).explicit.height)) { // explicit height is defined
			return (object as IMeasurable).explicit.height;
		} else if(object is IMeasurablePercent && !isNaN(total) && !isNaN((object as IMeasurablePercent).percentHeight)) { // support percent-based measurement
			return total * (object as IMeasurablePercent).percentHeight/percentageTotal;
		} else if(object is IMeasurable && (object as IMeasurable).measured != null && !isNaN((object as IMeasurable).measured.height)) { // measured width is defined
			return (object as IMeasurable).measured.height;
		} else if(object != null) { // we'll try to find a width anyways (even on non-DisplayObjects)
			try {
				return object.height;
			} catch(e:Error) {}
			return 0;
		} else {
			return 0;
		}
	}
}