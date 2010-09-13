package reflex.data
{
	import reflex.events.PropertyEvent;

	public class Scroll extends Range implements IScroll
	{
		private var _pageSize:Number = 10;
		[Bindable(event="pageSizeChange", noEvent)]
		public function get pageSize():Number { return _pageSize; }		
		public function set pageSize(value:Number):void {
			DataChange.change(this, "pageSize", _pageSize, _pageSize = value);
		}
		
		public function Scroll(min:Number = 0, max:Number = 100)
		{
			super(min, max);
		}
		
		
		public function pageForward():Number {
			return position += _pageSize;
		}
		
		public function pageBackward():Number {
			return position -= _pageSize;
		}
		
	}
}