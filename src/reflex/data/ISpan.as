package reflex.data
{
	public interface ISpan extends IProgress, IRange
	{
		
		function get stepSize():Number;
		function set stepSize(value:Number):void;
		
		function get skipSize():Number;
		function set skipSize(value:Number):void;
		
		function stepBackward():Number;
		function stepForward():Number;
		
		function skipBackward():Number;
		function skipForward():Number;
	}
}