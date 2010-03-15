package reflex.layout
{
	//import flight.utils.IMerging;
	//import flight.utils.IValueObject;

	[Bindable]
	public class Bounds
	{
		public var minWidth:Number = 0;
		public var minHeight:Number = 0;
		public var maxWidth:Number = Number.MAX_VALUE;
		public var maxHeight:Number = Number.MAX_VALUE;
		
		public function constrainWidth(width:Number):Number
		{
			return (width <= minWidth) ? minWidth :
				   (width >= maxWidth) ? maxWidth : width;
		}
		
		public function constrainHeight(height:Number):Number
		{
			return (height <= minHeight) ? minHeight :
				   (height >= maxHeight) ? maxHeight : height;
		}
		
		public function merge(bounds:Bounds):Bounds
		{
			if (bounds == null) {
				return this;
			}
			
			minWidth = minWidth >= bounds.minWidth ? minWidth : bounds.minWidth;
			minHeight = minHeight >= bounds.minHeight ? minHeight : bounds.minHeight;
			
			maxWidth = maxWidth <= bounds.maxWidth ? maxWidth : bounds.maxWidth;
			maxHeight = maxHeight <= bounds.maxHeight ? maxHeight : bounds.maxHeight;
			
			return this;
		}
		
		public function equals(bounds:Bounds):Boolean
		{
			if (bounds == null) {
				return false;
			}
			
			return (minWidth == bounds.minWidth && minHeight == bounds.minHeight &&
					maxWidth == bounds.maxWidth && maxHeight == bounds.maxHeight);
		}
		
		public function clone():Bounds
		{
			var bounds:Bounds = new Bounds();
				bounds.minWidth = minWidth;
				bounds.minHeight = minHeight;
				bounds.maxWidth = maxWidth;
				bounds.maxHeight = maxHeight;
			
			return bounds;
		}
		
	}
}