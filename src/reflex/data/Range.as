package reflex.data
{
	import flash.events.EventDispatcher;
	
	import reflex.events.PropertyEvent;

	public class Range extends EventDispatcher
	{
		
		private var _min:Number;
		private var _max:Number;
		
		public function Range(min:Number = NaN, max:Number = NaN)
		{
			_min = min;
			_max = max;
		}
		
		[Bindable(event="minChange")]
		public function get min():Number { return _min; }
		public function set min(value:Number):void {
			if(_min == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "min", _min, _min = value);
		}
		
		[Bindable(event="maxChange")]
		public function get max():Number { return _max;}
		public function set max(value:Number):void {
			if(_max == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "max", _max, _max = value);
		}
		
	}
}