package reflex.data
{
	import flash.events.EventDispatcher;
	
	public class Range extends EventDispatcher implements IRange
	{
		
		private var _min:Number = 0;
		[Bindable(event="minChange", noEvent)]
		public function get min():Number { return _min; }
		public function set min(value:Number):void {
			if (_min != value) {
				DataChange.queueChange(this, "min", _min, _min = value);
				if (_max < _min) {
					DataChange.queueChange(this, "max", _max, _max = _min);
				}
				position = _position;
				DataChange.completeChange(this, "min");
			}
		}
		
		private var _max:Number = 0;
		[Bindable(event="maxChange", noEvent)]
		public function get max():Number { return _max;}
		public function set max(value:Number):void {
			if (_max != value) {
				DataChange.queueChange(this, "max", _max, _max = value);
				if (_min > _max) {
					DataChange.queueChange(this, "min", _min, _min = _max);
				}
				position = _position;
				DataChange.completeChange(this, "max");
			}
		}
		
		private var _position:Number = 0;
		[Bindable(event="positionChange", noEvent)]
		public function get position():Number { return _position; }
		public function set position(value:Number):void {
			value = value <= _min ? _min : (value > _max ? _max : value);
			var p:Number = 1 / _precision;
			value = Math.round(value * p) / p;
			if (_position != value) {
				DataChange.queueChange(this, "position", _position, _position = value);
				value = _min == _max ? 0 : (_position - _min) / (_max - _min);
				DataChange.queueChange(this, "percent", _percent, _percent = value);
				DataChange.completeChange(this, "position");
			}
		}
		
		private var _percent:Number = 0;
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void {
			if (_percent != value) {
				position = _min + value * (_max - _min);
			}
		}
		
		private var _stepSize:Number = 1;
		[Bindable(event="stepSizeChange", noEvent)]
		public function get stepSize():Number { return _stepSize; }		
		public function set stepSize(value:Number):void {
			DataChange.change(this, "stepSize", _stepSize, _stepSize = value);
		}
		
		private var _precision:Number = _stepSize;
		[Bindable(event="precisionChange", noEvent)]
		public function get precision():Number { return _precision; }		
		public function set precision(value:Number):void {
			if (_precision != value) {
				DataChange.queueChange(this, "precision", _precision, _precision = value);
				position = _position;
				DataChange.completeChange(this, "precision");
			}
		}
		
		public function Range(min:Number = 0, max:Number = 10)
		{
			_min = min;
			_max = max;
		}
		
		
		public function stepForward():Number {
			return position += _stepSize;
		}
		
		public function stepBackward():Number {
			return position -= _stepSize;
		}
		
		
	}
}
