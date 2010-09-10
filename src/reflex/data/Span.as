package reflex.data
{
	import reflex.events.PropertyEvent;
	
	public class Span extends Progress implements ISpan
	{
		private var _stepSize:Number;
		private var _skipSize:Number;
		private var _min:Number;
		private var _max:Number;
		
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
			
		override public function set position(value:Number):void {
			if(super.position == value) {
				return;
			}
			var oldPercent:Number = super.percent;
			super.percent = (value - min) / (max - min);
			PropertyEvent.dispatchChange(this, "value", super.position, super.position = value);
			PropertyEvent.dispatchChange(this, "value", oldPercent, super.percent);
		}
		
		override public function set percent(value:Number):void {
			if(super.percent == value) {
				return;
			}
			var oldValue:Number = super.position;
			super.position = min + value * (max - min);
			PropertyEvent.dispatchChange(this, "value", super.percent, super.percent = value);
			PropertyEvent.dispatchChange(this, "value", oldValue, super.position);
		}
		
		override public function set size(value:Number):void {
		}
		
		[Bindable(event="skipSizeChange")]
		public function get skipSize():Number { return _skipSize; }		
		public function set skipSize(value:Number):void {
			if(_skipSize == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "skipSize", _skipSize, _skipSize = value);
		}
		
		[Bindable(event="stepSizeChange")]
		public function get stepSize():Number { return _stepSize; }		
		public function set stepSize(value:Number):void {
			if(_stepSize == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "stepSize", _stepSize, _stepSize = value);
		}
		
		
		public function Span(min:Number = NaN, max:Number = NaN, value:Number = NaN)
		{
			_min = min;
			_max = max;
			position = value;
		}
		
		
		public function stepForward():Number {
			return position += _stepSize;
		}
		
		public function stepBackward():Number {
			return position -= _stepSize;
		}
		
		
		public function skipForward():Number {
			return position += _skipSize;
		}
		
		public function skipBackward():Number {
			return position -= _skipSize;
		}
		
	}
}