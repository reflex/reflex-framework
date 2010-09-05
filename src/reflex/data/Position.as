package reflex.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import reflex.events.PropertyEvent;
	
	public class Position extends Range implements IPosition, IPositionControl
	{
		
		
		private var _value:Number;
		private var _stepSize:Number;
		
		[Bindable(event="valueChange")]
		public function get value():Number { return _value; }		
		public function set value(value:Number):void {
			if(_value == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "value", _value, _value = value);
		}
		
		[Bindable(event="stepSizeChange")]
		public function get stepSize():Number { return _stepSize; }		
		public function set stepSize(value:Number):void {
			if(_stepSize == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "stepSize", _stepSize, _stepSize = value);
		}
		
		
		public function Position(min:Number = NaN, max:Number = NaN, value:Number = NaN)
		{
			super(min, max);
			_value = value;
		}
		
		
		public function stepForward():Number {
			return value += _stepSize;
		}
		
		public function stepBackward():Number {
			return value -= _stepSize;
		}
		
	}
}