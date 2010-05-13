package reflex.measurement
{
	public interface IMeasurable
	{
		
		function get measurements():IMeasurements;
		function setSize(width:Number, height:Number):void;
		
	}
}