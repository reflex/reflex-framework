package reflex.data
{
	public interface IPagingControl extends IPositionControl
	{
		
		function get pageSize():Number;
		function set pageSize(value:Number):void;
		
		function pageBackward():Number;
		function pageForward():Number;
		
	}
}