package flight.position
{
	import flash.events.EventDispatcher;
	
	import flight.events.PropertyEvent;
	
	public class Position extends EventDispatcher implements IPosition
	{
		[Bindable]
		public var stepSize:Number = 1;
		
		[Bindable]
		public var skipSize:Number = 5;
		
		public var precision:Number = stepSize;
		
		private var _position:Number = 0;
		private var _percent:Number = 0;
		private var _size:Number = 1;
		private var _min:Number = 0;
		private var _max:Number = 10;
		private var _positionSize:Number = 0;
		
		[Bindable(event="positionChange")]
		public function get position():Number
		{
			return _position;
		}
		public function set position(value:Number):void
		{
			value = value <= _min ? _min : (value >= _max ? _max : value);
			var p:Number = 1 / precision;
			value = Math.round(value * p) / p;
			if (_position == value) {
				return;
			}
			
			var oldValues:Array = [_position, _percent];
			_position = value;
			var space:Number = (_max - _positionSize - _min);
			_percent = space == 0 ? 1 : _position / space;
			
			PropertyEvent.dispatchChangeList(this, ["position", "percent"], oldValues);
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
			
			var space:Number = (_max - _positionSize - _min);
			position = _min + value * space;
		}
		
		[Bindable(event="sizeChange")]
		public function get size():Number
		{
			return _size;
		}
		public function set size(value:Number):void
		{
			value = value <= 0 ? 0 : value;
			if (_size == value) {
				return;
			}
			
			var oldValues:Array = [_size, _max];
			_size = value;
			_max = _min + _positionSize + _size;
			
			position = position;
			PropertyEvent.dispatchChangeList(this, ["size", "max"], oldValues);
		}
		
		[Bindable(event="minChange")]
		public function get min():Number
		{
			return _min;
		}
		public function set min(value:Number):void
		{
			if (_min == value) {
				return;
			}
			
			var properties:Array = ["min", "size"];
			var oldValues:Array = [_min, _size];
			_min = value;
			
			if (_max < _min) {
				properties.push("max");
				oldValues.push(_max);
				_max = _min;
			}
			if (_positionSize > _max - _min) {
				properties.push("positionSize");
				oldValues.push(_positionSize);
				_positionSize = _max - _min;
			}
			_size = _max - _positionSize - _min;
			
			position = position;
			PropertyEvent.dispatchChangeList(this, properties, oldValues);
		}
		
		[Bindable(event="maxChange")]
		public function get max():Number
		{
			return _max;
		}
		public function set max(value:Number):void
		{
			if (_max == value) {
				return;
			}
			
			var properties:Array = ["max", "size"]
			var oldValues:Array = [_max, _size];
			_max = value;
			
			if (_min > _max) {
				properties.push("min");
				oldValues.push(_min);
				_min = _max;
			}
			if (_positionSize > _max - _min) {
				properties.push("positionSize");
				oldValues.push(_positionSize);
				_positionSize = _max - _min;
			}
			_size = _max - _positionSize - _min;
			
			position = position;
			PropertyEvent.dispatchChangeList(this, properties, oldValues);
		}
		
		[Bindable(event="positionSizeChange")]
		public function get positionSize():Number
		{
			return _positionSize;
		}
		public function set positionSize(value:Number):void
		{
			value = Math.min(_max - _min, value);
			if (_positionSize == value) {
				return;
			}
			
			var oldValues:Array = [_positionSize, _size];
			_positionSize = value;
			_size = _max - _positionSize - _min;
			
			PropertyEvent.dispatchChangeList(this, ["positionSize", "size"], oldValues);
		}
		
		public function forward():void
		{
			position += stepSize;
		}
		
		public function backward():void
		{
			position -= stepSize;
		}
		
		public function skipForward():void
		{
			position += skipSize;
		}
		
		public function skipBackward():void
		{
			position -= skipSize;
		}
	}
}
