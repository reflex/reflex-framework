package flight.utils
{
	/**
	 * IValueObject is a common interface for many data structures, allowing
	 * complex objects to be treated as simple types, as value versus reference.
	 * 
	 * <p>A value object is an object that can be compared by the values of its
	 * properties rather than its identiy. Two value objects may be equal
	 * because their data is identical, even if they are individual reference
	 * objects in ActionScript. Through implementing equals() two value objects
	 * can be compared by their data, while clone() allows value objects to be
	 * passed by value (as copies).</p>
	 * 
	 * @see		#equals
	 * @see		#clone
	 */
	public interface IValueObject
	{
		/**
		 * Evaluates the equality of another object of the same type, based on
		 * its properties.
		 * 
		 * @param	value			The target of the comparison.
		 * @return					True if all values of each object are equal. 
		 */
		function equals(value:Object):Boolean;
		
		/**
		 * Returns a new object that is an exact copy of this object.
		 * 
		 * @return					The replicated object.
		 */
		function clone():Object;
	}
}
