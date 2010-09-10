package reflex.data
{
	import reflex.events.PropertyEvent;

	public class Scroll extends Span implements IScroll
	{
		
		public function get filled():Boolean
		{
			return false;
		}
		
		
		private var _pageSize:Number;
		
		override public function set position(value:Number):void {
			if(super.position == value) {
				return;
			}
			var oldPercent:Number = super.percent;
			super.percent = (value - pageSize - min) / (max - pageSize - min);
			PropertyEvent.dispatchChange(this, "value", super.position, super.position = value);
			PropertyEvent.dispatchChange(this, "percent", oldPercent, super.percent);
		}
		
		override public function set percent(value:Number):void {
			if(super.percent == value) {
				return;
			}
			var oldValue:Number = super.position;
			super.position = min + value * (max - pageSize - min);
			PropertyEvent.dispatchChange(this, "percent", super.percent, super.percent = value);
			PropertyEvent.dispatchChange(this, "value", oldValue, super.position);
		}
		
		[Bindable(event="pageSizeChange")]
		public function get pageSize():Number { return _pageSize; }		
		public function set pageSize(value:Number):void {
			if(_pageSize == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "pageSize", _pageSize, _pageSize = value);
		}
		
		
		public function Scroll(min:Number=NaN, max:Number=NaN, value:Number=NaN)
		{
			super(min, max, value);
		}
		
	}
}