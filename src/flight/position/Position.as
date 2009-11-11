package flight.position
{
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class Position extends EventDispatcher implements IPosition
	{
		public var type:String = "";
		public var stepSize:Number = 0.01;
		public var skipSize:Number = 0.1;
		
		
		private var _position:Number = 0;
		private var _percent:Number = 0;
		private var _size:Number = 1;
		private var _min:Number = 0;
		private var _max:Number = 1;
		private var _positionSize:Number = 0;
		
		public function get position():Number
		{
			return _position;
		}
		public function set position(value:Number):void
		{
			value = Math.max(_min, Math.min(_max - _positionSize, value));
			if (_position == value) {
				return;
			}
			_position = value;
			var space:Number = (_max - _positionSize - _min);
			percent = space == 0 ? 1 : _position / space;
		}
		
		public function get percent():Number
		{
			return _percent;
		}
		public function set percent(value:Number):void
		{
			value = Math.max(0, Math.min(1, value));
			if (_percent == value) {
				return;
			}
			_percent = value;
			var space:Number = (_max - _positionSize - _min);
			position = _min + _percent * space;
		}
		
		public function get size():Number
		{
			return _size;
		}
		public function set size(value:Number):void
		{
			value = Math.max(0, value);
			if (_size == value) {
				return;
			}
			_size = value;
			
			max = _min + _positionSize + _size;
			position = position;
		}
		
		public function get min():Number
		{
			return _min;
		}
		public function set min(value:Number):void
		{
			if (_min == value) {
				return;
			}
			_min = value;
			
			if (_max < _min) {
				max = _min;
			}
			if (_positionSize > _max - _min) {
				positionSize = _max - _min;
			}
			size = _max - _positionSize - _min;
			position = position;
		}
		
		public function get max():Number
		{
			return _max;
		}
		public function set max(value:Number):void
		{
			if (_max == value) {
				return;
			}
			_max = value;
			
			if (_min > _max) {
				min = _max;
			}
			if (_positionSize > _max - _min) {
				positionSize = _max - _min;
			}
			size = _max - _positionSize - _min;
			position = position;
		}
		
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
			_positionSize = value;
			size = _max - _positionSize - _min;
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
