package flight.utils
{
	/**
	 * The IMerging interface represents the ability for an object to combine
	 * another object's data to itself.
	 */
	public interface IMerging
	{
		/**
		 * Merges a source object's data to this object to some degree. This is
		 * a one-way operation and does not effect the state of the source.
		 * 
		 * @param	source			Source of data to be merged. Often required
		 * 							to be of the same type as this object.
		 */
		function merge(source:Object):Boolean;
	}
}