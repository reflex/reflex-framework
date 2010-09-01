package reflex.data
{
	public interface ISnappingPosition extends IPosition
	{
		
		function get snappingPositions():Array;
		function set snappingPositions(value:Array):void;
		
		function get snappingThreshold():Number;
		function set snappingThreshold(value:Number):void;
		
	}
}