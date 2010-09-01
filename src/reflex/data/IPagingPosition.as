package reflex.data
{
	public interface IPagingPosition extends IPosition
	{
		
		function get stepSize():Number;
		function set stepSize(value:Number):void;
		
		function get pageSize():Number;
		function set pageSize(value:Number):void;
		
	}
}