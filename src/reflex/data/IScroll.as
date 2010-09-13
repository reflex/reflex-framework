package reflex.data
{
	public interface IScroll extends IRange
	{
		function get pageSize():Number;
		function set pageSize(value:Number):void;
		
		function pageBackward():Number;
		function pageForward():Number;
	}
}