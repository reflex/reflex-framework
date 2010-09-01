package reflex.data
{
	import mx.controls.scrollClasses.ScrollBar;
	
	import spark.components.HSlider;
	
	public class PositionUtil
	{
		
		static public function forward(position:IPosition):void
		{
			var stepSize:Number = 1;
			if(position is IPagingPosition) {
				stepSize = (position as IPagingPosition).stepSize;
			} else {
				stepSize = (position.max - position.min) / 100;
			}
			position.value += stepSize;
		}
		
		static public function backward(position:IPosition):void
		{
			var stepSize:Number = 1;
			if(position is IPagingPosition) {
				stepSize = (position as IPagingPosition).stepSize;
			} else {
				stepSize = (position.max - position.min) / 100;
			}
			position.value -= stepSize;
		}
		
		static public function pageForward(position:IPosition):void
		{
			var pageSize:Number = 10;
			if(position is IPagingPosition) {
				pageSize = (position as IPagingPosition).pageSize;
			} else {
				pageSize = (position.max - position.min) / 10;
			}
			position.value += pageSize;
		}
		
		static public function pageBackward(position:IPosition):void
		{
			var pageSize:Number = 10;
			if(position is IPagingPosition) {
				pageSize = (position as IPagingPosition).pageSize;
			} else {
				pageSize = (position.max - position.min) / 10;
			}
			position.value -= pageSize;
		}
		
		static public function setPercent(position:IPosition, percent:Number):void {
			position.value = (position.max - position.min) * percent + position.min;
		}
		
		static public function resolvePercent(position:IPosition):Number {
			return (position.value - position.min) / (position.max - position.min);
		}
		
	}
}