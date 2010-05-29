package reflex.measurement
{
	
	/**
	 * @alpha
	 */
	public class Measurements implements IMeasurements
	{
		
		private var _expliciteWidth:Number;
		private var _expliciteHeight:Number;
		
		private var _measuredWidth:Number;
		private var _measuredHeight:Number;
		
		// todo: update for defined events
		
		[Bindable] public var minWidth:Number;
		[Bindable] public var minHeight:Number;
		
		[Bindable] public var maxWidth:Number;
		[Bindable] public var maxHeight:Number;
		
		[Bindable]
		public function get expliciteWidth():Number { return _expliciteWidth; }
		public function set expliciteWidth(value:Number):void {
			_expliciteWidth = value;
		}
		
		[Bindable]
		public function get expliciteHeight():Number { return _expliciteHeight; }
		public function set expliciteHeight(value:Number):void {
			_expliciteHeight = value;
		}
		
		[Bindable] public var percentWidth:Number;
		[Bindable] public var percentHeight:Number;
		
		[Bindable]
		public function get measuredWidth():Number { return _measuredWidth; }
		public function set measuredWidth(value:Number):void {
			_measuredWidth = value;
		}
		
		[Bindable]
		public function get measuredHeight():Number { return _measuredHeight; }
		public function set measuredHeight(value:Number):void {
			_measuredHeight = value;
		}
		
		//private var _target:Object;
		
		public function Measurements(defaultWidth:Number = 160, defaultHeight:Number = 22) {
			measuredWidth = defaultWidth;
			measuredHeight = defaultHeight;
		}
		
	}
}