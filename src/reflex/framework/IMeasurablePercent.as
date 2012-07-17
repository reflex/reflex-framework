package reflex.framework
{
	
	/**
	 * Implemented by objects that want to participate in percetage-based layouts.
	 */
	public interface IMeasurablePercent
	{
		
		/**
		 * Holds an object's preference for width as a percentage (0-100).
		 */
		function get percentWidth():Number;
		function set percentWidth(value:Number):void;
		
		/**
		 * Holds an object's preference for height as a percentage (0-100).
		 */
		function get percentHeight():Number;
		function set percentHeight(value:Number):void;
		
	}
}