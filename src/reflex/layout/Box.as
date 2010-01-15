package reflex.layout
{
	import flash.events.EventDispatcher;
	
	import flight.utils.IMerging;
	import flight.utils.IValueObject;
	
	[Bindable]
	public class Box extends EventDispatcher
	{
		public var left:Number;
		public var top:Number;
		public var right:Number;
		public var bottom:Number;
		
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		public var horizontal:Number = 0;
		public var vertical:Number = 0;
		
		public function Box(left:Number = 0, top:Number = 0, right:Number = 0, bottom:Number = 0)
		{
			this.left = left;
			this.top = top;
			this.right = right;
			this.bottom = bottom;
		}
		
		public function merge(box:Box):Box
		{
			if (box == null) {
				return this;
			}
			
			left = left >= box.left ? left : box.left;
			top = top >= box.top ? top : box.top;
			right = right >= box.right ? right : box.right;
			bottom = bottom >= box.bottom ? bottom : box.bottom;
			
			return this;
		}
		
		public function equals(box:Box):Boolean
		{
			if (box == null) {
				return false;
			}
			
			return (left == box.left && right == box.right &&
					top == box.top && bottom == box.bottom &&
					offsetX == box.offsetX && offsetY == box.offsetY &&
					horizontal == box.horizontal && vertical == box.vertical);
		}
		
		public function clone():Box
		{
			var box:Box = new Box(left, top, right, bottom);
				box.offsetX = offsetX;
				box.offsetY = offsetY;
				box.horizontal = horizontal;
				box.vertical = vertical;
			
			return box;
		}
		
		public static function fromString(value:String):Box
		{
			var box:Box = new Box();
			
			if (!value) {
				return box;
			}
			
			var values:Array = value.split(" ");
			switch (values.length) {
				case 1 :
					box.left = box.top = box.right = box.bottom = parseFloat( values[0] );
					break;
				case 2 :
					box.left = box.right = parseFloat( values[1] );
					box.top = box.bottom = parseFloat( values[0] );
					break;
				case 3 :
					box.left = box.right = parseFloat( values[1] );
					box.top = parseFloat( values[0] );
					box.bottom = parseFloat( values[2] );
					break;
				case 4 :
					box.left = parseFloat( values[3] );
					box.top = parseFloat( values[0] );
					box.right = parseFloat( values[1] );
					box.bottom = parseFloat( values[2] );
					break;
			}
			
			return box;
		}
		
		override public function toString():String
		{
			return '[Box(left="' + left + '", top="' + top + ', right="' + right + '", bottom="' + bottom + '")]'; 
		}
	}
}