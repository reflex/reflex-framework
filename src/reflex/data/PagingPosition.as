package reflex.data
{
	import reflex.events.PropertyEvent;

	public class PagingPosition extends Position implements IPagingControl
	{
		
		private var _pageSize:Number;
		
		[Bindable(event="pageSizeChange")]
		public function get pageSize():Number { return _pageSize; }		
		public function set pageSize(value:Number):void {
			if(_pageSize == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "pageSize", _pageSize, _pageSize = value);
		}
		
		
		public function PagingPosition(min:Number=NaN, max:Number=NaN, value:Number=NaN)
		{
			super(min, max, value);
		}
		
		
		public function pageForward():Number {
			return value += _pageSize;
		}
		
		public function pageBackward():Number {
			return value -= _pageSize;
		}
		
	}
}