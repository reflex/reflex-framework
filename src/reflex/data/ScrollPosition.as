package reflex.data
{
	
	public class ScrollPosition extends Position implements IPagingPosition
	{
		
		private var _pageSize:Number = 10;
		
		[Bindable(event="pageSizeChange", noEvent)]
		public function get pageSize():Number { return _pageSize; }		
		public function set pageSize(value:Number):void {
			notify("pageSize", _pageSize, _pageSize = value);
		}
		
		public function ScrollPosition(minimum:Number = 0, maximum:Number = 100, value:Number = 0, stepSize:Number = 1, pageSize:Number = 10)
		{
			super(minimum, maximum, value, stepSize);
			_pageSize = pageSize;
		}
		
	}
}