package reflex.data
{
	import flash.events.EventDispatcher;
	
	import reflex.events.PropertyEvent;

	public class Progress extends EventDispatcher implements IProgress
	{
		private var _position:Number;
		private var _percent:Number;
		private var _size:Number;
		
		[Bindable(event="valueChange")]
		public function get position():Number { return _position; }		
		public function set position(value:Number):void {
			if(_position == value) {
				return;
			}
			var oldPercent:Number = _percent;
			_percent = value / _size;
			PropertyEvent.dispatchChange(this, "value", _position, _position = value);
			PropertyEvent.dispatchChange(this, "value", oldPercent, _percent);
		}
		
		[Bindable(event="percentChange")]
		public function get percent():Number { return _position; }		
		public function set percent(value:Number):void {
			if(_percent == value) {
				return;
			}
			var oldValue:Number = _position;
			_position = value * _size;
			PropertyEvent.dispatchChange(this, "value", _percent, _percent = value);
			PropertyEvent.dispatchChange(this, "value", oldValue, _position);
		}
		
		[Bindable(event="sizeChange")]
		public function get size():Number { return _size; }		
		public function set size(value:Number):void {
		}
	}
}