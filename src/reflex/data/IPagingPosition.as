package reflex.data
{
	public interface IPagingPosition extends IPosition
	{
		
		[Bindable(event="pageSizeChange")]
		function get pageSize():Number;
		function set pageSize(value:Number):void;
		
	}
}