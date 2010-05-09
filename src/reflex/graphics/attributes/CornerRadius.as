package reflex.graphics.attributes
{
	
	/**
	 * @private
	 **/
	public final class CornerRadius
	{
		public var topLeft:Number;
		public var topRight:Number;
		public var bottomLeft:Number;
		public var bottomRight:Number;
		
		private static var pool:CornerRadius;
		private var next:CornerRadius;
		
		public function CornerRadius(topLeft:Number = 0, topRight:Number = 0, bottomLeft:Number = 0, bottomRight:Number = 0)
		{
			this.topLeft = topLeft;
			this.topRight = topRight;
			this.bottomLeft = bottomLeft;
			this.bottomRight = bottomRight;
		}
		
		public function inset(delta:Number):void
		{
			topLeft = Math.max(0, topLeft - delta);
			topRight = Math.max(0, topRight - delta);
			bottomLeft = Math.max(0, bottomLeft - delta);
			bottomRight = Math.max(0, bottomRight - delta);
		}
		
		public function allZero():Boolean
		{
			return topLeft == 0 && topRight == 0 && bottomLeft == 0 && bottomRight == 0;
		}
		
		public function equals(toCompare:CornerRadius):Boolean
		{
			return (toCompare.topLeft == topLeft &&
				toCompare.topRight == topRight &&
				toCompare.bottomLeft == bottomLeft &&
				toCompare.bottomRight == bottomRight);
		}
		
		public function clone():CornerRadius
		{
			return new CornerRadius(topLeft, topRight, bottomLeft, bottomRight);
		}
		
		public function dispose():void
		{
			topLeft = 0;
			topRight = 0;
			bottomLeft = 0;
			bottomRight = 0;
			next = pool;
			pool = this;
		}
		
		
		private static var numberRegex:RegExp = new RegExp("\\s+", "g");
		
		public static function fromString(value:String):CornerRadius
		{
			var corners:CornerRadius = pool || new CornerRadius();
			pool = corners.next;
			
			if (!value) return corners;
			
			var numbers:Array = value.split(numberRegex);
			var n:int = numbers.length;
			for (var i:int = 0; i < n; i++) {
				numbers[i] = Length.fromString(numbers[i]);
			}
			
			if (n == 1) {
				corners.topLeft = corners.topRight = corners.bottomLeft = corners.bottomRight = numbers[0];
			} else if (n == 2) {
				corners.topLeft = corners.topRight = numbers[0];
				corners.bottomLeft = corners.bottomRight = numbers[1];
			} else if (n == 4) {
				corners.topLeft = numbers[0];
				corners.topRight = numbers[1];
				corners.bottomLeft = numbers[2];
				corners.bottomRight = numbers[3];
			} else {
				throw new ArgumentError("Corners require 1, 2, or 4 Length parameters");
			}
			
			return corners;
		}
		
		public function toString():String
		{
			return '[Edges(topLeft="' + topLeft + ', topRight="' + topRight + '", bottomLeft="' + bottomLeft + '", bottomRight="' + bottomRight + '")]'; 
		}
	}
}