package reflex.data
{
	public interface IPositionControl
	{
		
		function get stepSize():Number;
		function set stepSize(value:Number):void;
		
		function stepBackward():Number;
		function stepForward():Number;
		
	}
}