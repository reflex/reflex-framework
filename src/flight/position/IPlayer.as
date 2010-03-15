package flight.position
{
	public interface IPlayer extends IProgress
	{
		function play():void
		function pause():void;
		function stop():void;
		
		function seek(position:Number = 0):void;
	}
}