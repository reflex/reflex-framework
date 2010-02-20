package flight.position
{
	import flash.events.EventDispatcher;
	
	import flight.events.PropertyEvent;
	
	public class Position extends EventDispatcher implements IPosition
	{
		[Bindable]
		public var stepSize:Number = 1;
		
		[Bindable]
		public var skipSize:Number = 2;
		
		public var precision:Number = stepSize;
		
		private var _value:Number = 0;
		private var _percent:Number = 0;
		private var _size:Number = 10;
		private var _min:Number = 0;
		private var _max:Number = _size;
		private var _space:Number = 0;
		private var _filled:Boolean = false;
		
		[Bindable(event="filledChange")]
		public function get filled():Boolean
		{
			return _filled;
		}
		
		[Bindable(event="valueChange")]
		public function get value():Number
		{
			return _value;
		}
		public function set value(value:Number):void
		{
			var space:Number = _space >= _size ? _size : _space;
			value = value <= _min ? _min : (value > _max - space ? _max - space : value);
			var p:Number = 1 / precision;
			value = Math.round(value * p) / p;
			
			_value = PropertyEvent.change(this, "value", _value, value);
			var area:Number = _size - space;
			value = area == 0 ? 0 : (_value - _min) / area;
			_percent = PropertyEvent.change(this, "percent", _percent, value);
			
			PropertyEvent.dispatch(this);
		}
		
		[Bindable(event="percentChange")]
		public function get percent():Number
		{
			return _percent;
		}
		public function set percent(value:Number):void
		{
			if (_percent == value) {
				return;
			}
			
			var space:Number = _space >= _size ? _size : _space;
			var area:Number = _size - space;
			this.value = _min + value * area;
		}
		
		[Bindable(event="sizeChange")]
		public function get size():Number
		{
			return _size;
		}
		public function set size(value:Number):void
		{
			value = value <= 0 ? 0 : value;
			var p:Number = 1 / precision;
			value = Math.round(value * p) / p;
			if (_size == value) {
				return;
			}
			
			_size = PropertyEvent.change(this, "size", _size, value);
			_max = PropertyEvent.change(this, "max", _max, _min + _size);
			_filled = PropertyEvent.change(this, "filled", _filled, _space >= _size);
			
			this.value = _value;
			PropertyEvent.dispatch(this);
		}
		
		[Bindable(event="minChange")]
		public function get min():Number
		{
			return _min;
		}
		public function set min(value:Number):void
		{
			var p:Number = 1 / precision;
			value = Math.round(value * p) / p;
			if (_min == value) {
				return;
			}
			
			_min = PropertyEvent.change(this, "min", _min, value);
			if (_max < _min) {
				_max = PropertyEvent.change(this, "max", _size, _min);
			}
			_size = PropertyEvent.change(this, "size", _size, _max - _min);
			_filled = PropertyEvent.change(this, "filled", _filled, _space >= _size);
			
			this.value = _value;
			PropertyEvent.dispatch(this);
		}
		
		[Bindable(event="maxChange")]
		public function get max():Number
		{
			return _max;
		}
		public function set max(value:Number):void
		{
			var p:Number = 1 / precision;
			value = Math.round(value * p) / p;
			if (_max == value) {
				return;
			}
			
			_max = PropertyEvent.change(this, "max", _max, value);
			if (_min > _max) {
				_min = PropertyEvent.change(this, "min", _min, _max);
			}
			_size = PropertyEvent.change(this, "size", _size, _max - _min);
			_filled = PropertyEvent.change(this, "filled", _filled, _space >= _size);
			
			this.value = _value;
			PropertyEvent.dispatch(this);
		}
		
		[Bindable(event="spaceChange")]
		public function get space():Number
		{
			return _space;
		}
		public function set space(value:Number):void
		{
			var p:Number = 1 / precision;
			value = Math.round(value * p) / p;
			if (_space == value) {
				return;
			}
			
			_space = PropertyEvent.change(this, "space", _space, value);
			_filled = PropertyEvent.change(this, "filled", _filled, _space >= _size);
			
			this.value = _value;
			PropertyEvent.dispatch(this);
		}
		
		public function forward():void
		{
			value += stepSize;
		}
		
		public function backward():void
		{
			value -= stepSize;
		}
		
		public function skipForward():void
		{
			value += skipSize;
		}
		
		public function skipBackward():void
		{
			value -= skipSize;
		}
	}
}
