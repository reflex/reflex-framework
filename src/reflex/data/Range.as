package reflex.data
{
	import flash.events.EventDispatcher;
	import reflex.binding.DataChange;
	
	public class Range extends EventDispatcher implements IRange
	{
		
		private var _minimum:Number = 0;
		private var _maximum:Number = 0;
		
		[Bindable(event="minimumChange", noEvent)]
		public function get minimum():Number { return _minimum; }
		public function set minimum(value:Number):void {
			DataChange.change(this, "min", _minimum, _minimum = value);
		}
		
		[Bindable(event="maximumChange", noEvent)]
		public function get maximum():Number { return _maximum;}
		public function set maximum(value:Number):void {
			DataChange.change(this, "max", _maximum, _maximum = value);
		}
		
		public function Range(minimum:Number = 0, maximum:Number = 100)
		{
			_minimum = minimum;
			_maximum = maximum;
		}
		
	}
}
