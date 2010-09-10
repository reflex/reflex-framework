package reflex.data
{
	public interface IProgress
	{
		
		function get position():Number;
		function set position(value:Number):void;
		
		function get percent():Number;
		function set percent(value:Number):void;
		
		function get size():Number;
		function set size(value:Number):void;
	}
}