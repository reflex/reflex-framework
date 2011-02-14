package reflex.components {
	import reflex.data.IPosition;
	
	public class MockPosition implements IPosition {
		public function MockPosition() {
		}

		private var _value:Number;
		private var _minimum:Number;
		private var _maximum:Number;

		public function get value():Number { return _value; }
		public function set value(newValue:Number):void {
			_value = newValue;
		}
		
		public function get minimum():Number { return _minimum; }
		public function set minimum(value:Number):void {
			_minimum = value;
		}
		
		public function get maximum():Number { return _maximum; }
		public function set maximum(value:Number):void {
			_maximum = value;
		}
	}
}