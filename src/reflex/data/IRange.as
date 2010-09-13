package reflex.data
{
	public interface IRange
	{
		function get min():Number;
		function set min(value:Number):void;
		
		function get max():Number;
		function set max(value:Number):void;
		
		function get position():Number;
		function set position(value:Number):void;
		
		function get percent():Number;
		function set percent(value:Number):void;
		
		function get stepSize():Number;
		function set stepSize(value:Number):void;
		
		function stepBackward():Number;
		function stepForward():Number;
		
	}
}