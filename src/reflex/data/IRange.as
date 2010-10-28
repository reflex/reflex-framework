package reflex.data
{
	public interface IRange
	{
		
		[Bindable(event="minimumChange")]
		function get minimum():Number;
		function set minimum(value:Number):void;
		
		[Bindable(event="maximumChange")]
		function get maximum():Number;
		function set maximum(value:Number):void;
		
	}
}