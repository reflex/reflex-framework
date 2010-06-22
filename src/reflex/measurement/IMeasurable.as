package reflex.measurement
{
	public interface IMeasurable
	{
		
		function get width():Number;
		function set width(value:Number):void;
		
		function get height():Number;
		function set height(value:Number):void;
		
		function get measurements():IMeasurements;
		function setSize(width:Number, height:Number):void;
		
	}
}