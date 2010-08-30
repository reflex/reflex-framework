package reflex.measurement
{
	
	/**
	 * Implemented by objects that want to have implicite measurements.
	 * In this system objects calculate implicite measurement preferences, but still allow explicite measurements to be set in AS3 or MXML.
	 * This interface is NOT required for items to be added to containers or to participate in Reflex's layout system.
	 */
	public interface IMeasurable
	{
		
		function get width():Number;
		function set width(value:Number):void;
		
		function get height():Number;
		function set height(value:Number):void;
		/*
		function get minWidth():Number;
		function set minWidth(value:Number):void;
		
		function get minHeight():Number;
		function set minHeight(value:Number):void;
		
		function get maxWidth():Number;
		function set maxWidth(value:Number):void;
		
		function get maxHeight():Number;
		function set maxHeight(value:Number):void;
		*/
		
		/**
		 * Holds explicite width/height values which have been assigned directly in AS3 or MXML.
		 */
		function get explicite():IMeasurements;
		
		/**
		 * Holds implicite width/height values which have been calculated internally.
		 */
		function get measured():IMeasurements;
		
		/**
		 * Sets width and height properties without effecting measurement.
		 * Use cases include layout and animation/tweening.
		 */
		function setSize(width:Number, height:Number):void;
		
	}
}