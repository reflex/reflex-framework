package flight.position
{
	public interface IPosition extends IProgress
	{
		function get min():Number;
		function set min(value:Number):void;
		
		function get max():Number;
		function set max(value:Number):void;
		
		function get positionSize():Number;
		function set positionSize(value:Number):void;
		
		function get stepSize():Number;
		function set stepSize(value:Number):void;
		
		function get skipSize():Number;
		function set skipSize(value:Number):void;
		
		function forward():void;
		function backward():void;
		
		function skipForward():void;
		function skipBackward():void;
		
		
	}
}
