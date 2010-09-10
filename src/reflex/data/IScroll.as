package reflex.data
{
	public interface IScroll extends ISpan
	{
		
		function get filled():Boolean;
		
		function get pageSize():Number;
		function set pageSize(value:Number):void;
	}
}