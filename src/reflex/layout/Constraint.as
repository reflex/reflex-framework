package reflex.layout
{
	import flight.utils.IMerging;
	import flight.utils.IValueObject;

	[Bindable]
	public class Constraint implements IMerging, IValueObject
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
		
		public function merge(source:Object):Boolean
		{
			var constraint:Constraint = source as Constraint;
			if (constraint == null) {
				return false;
			}
			
			minWidth = minWidth >= constraint.minWidth ? minWidth : constraint.minWidth;
			minHeight = minHeight >= constraint.minHeight ? minHeight : constraint.minHeight;
			
			maxWidth = maxWidth <= constraint.maxWidth ? maxWidth : constraint.maxWidth;
			maxHeight = maxHeight <= constraint.maxHeight ? maxHeight : constraint.maxHeight;
			
			return true;
		}
		
		public function equals(value:Object):Boolean
		{
			var constraint:Constraint = value as Constraint;
			if (constraint == null) {
				return false;
			}
			
			if (minWidth == constraint.minWidth && minHeight == constraint.minHeight &&
				maxWidth == constraint.maxWidth && maxHeight == constraint.maxHeight) {
				return true;
			}
			
			return false;
		}
		
		public function clone():Object
		{
			var constraint:Constraint = new Constraint();
				constraint.minWidth = minWidth;
				constraint.minHeight = minHeight;
				constraint.maxWidth = maxWidth;
				constraint.maxHeight = maxHeight;
			
			return constraint;
		}
		
	}
}