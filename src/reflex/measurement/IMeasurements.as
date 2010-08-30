package reflex.measurement
{
	
	/**
	 * Implemented by objects which hold values related to display dimensions (width/height).
	 */
	public interface IMeasurements
	{
		
		function get width():Number;
		function set width(value:Number):void;
		
		function get height():Number;
		function set height(value:Number):void;
		
		function get minWidth():Number;
		function set minWidth(value:Number):void;
		
		function get minHeight():Number;
		function set minHeight(value:Number):void;
		
	}
}