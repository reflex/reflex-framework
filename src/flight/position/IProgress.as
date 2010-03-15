package flight.position
{
	/**
	 * Base interface for all types that represent a progression.
	 */
	public interface IProgress
	{
		/**
		 * The current position in the progression, between 0 and
		 * <code>length</code>.
		 */
		function get value():Number;
		function set value(value:Number):void;
		
		/**
		 * The percent complete in the progress, as a number between 0 and 1
		 * with 1 being 100% complete.
		 */
		function get percent():Number;
		function set percent(value:Number):void;
		
		/**
		 * The total length of the progression.
		 */
		function get size():Number;
		function set size(value:Number):void;
		
	}
}
