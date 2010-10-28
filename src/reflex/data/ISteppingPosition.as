package reflex.data
{
	public interface ISteppingPosition extends IPosition
	{
		
		[Bindable(event="stepSizeChange")]
		function get stepSize():Number;
		function set stepSize(value:Number):void;
		
	}
}