package reflex.data
{
	public interface IPosition extends IRange
	{
		
		[Bindable(event="valueChange")]
		function get value():Number;
		function set value(value:Number):void;
		
	}
}