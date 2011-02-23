package reflex.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import reflex.binding.DataChange;
	
	public class Position extends Range implements IPosition, ISteppingPosition
	{
		
		private var _value:Number = 0;
		private var _stepSize:Number = 0;
		
		[Bindable(event="valueChange")]
		public function get value():Number { return _value; }
		public function set value(value:Number):void {
			DataChange.change(this, "value", _value, _value = value);
		}
		
		[Bindable(event="stepSizeChange")]
		public function get stepSize():Number { return _stepSize; }
		public function set stepSize(value:Number):void {
			DataChange.change(this, "stepSize", _stepSize, _stepSize = value);
		}
		
		public function Position(minimum:Number = 0, maximum:Number = 100, value:Number = 0, stepSize:Number = 1)
		{
			super(minimum, maximum);
			_value = value;
			_stepSize = stepSize;
		}
	}
}