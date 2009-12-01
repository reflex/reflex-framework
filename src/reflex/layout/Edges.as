package reflex.layout
{
	

	public final class Edges
	{
		public var top:Number;
		public var right:Number;
		public var bottom:Number;
		public var left:Number;
		
		public function Edges(top:Number = 0, right:Number = 0, bottom:Number = 0, left:Number = 0)
		{
			this.top = top;
			this.right = right;
			this.bottom = bottom;
			this.left = left;
		}
		
		public function equals(toCompare:Edges):Boolean
		{
			return (toCompare.top == top &&
				toCompare.right == right &&
				toCompare.bottom == bottom &&
				toCompare.left == left);
		}
		
		public function clone():Edges
		{
			return new Edges(top, right, bottom, left);
		}
		
		
		private static var numberRegex:RegExp = new RegExp("\\s+", "g");
		
		public static function fromString(value:String):Edges
		{
			var edges:Edges = new Edges();
			
			if (!value) return edges;
			
			var numbers:Array = value.split(whitespaceRegex);
			var n:int = numbers.length;
			for (var i:int = 0; i < n; i++) {
				numbers[i] = Length.fromString(numbers[i]);
			}
			
			if (n == 1) {
				edges.top = edges.right = edges.bottom = edges.left = numbers[0];
			} else if (n == 2) {
				edges.top = edges.bottom = numbers[0];
				edges.right = edges.left = numbers[1];
			} else if (n == 3) {
				edges.top = numbers[0];
				edges.right = edges.left = numbers[1];
				edges.bottom = numbers[2];
			} else if (n == 4) {
				edges.top = numbers[0];
				edges.right = numbers[1];
				edges.bottom = numbers[2];
				edges.left = numbers[3];
			}
			
			return edges;
		}
		
		public function toString():String
		{
			return '[Edges(top="' + top + ', right="' + right + '", bottom="' + bottom + '", left="' + left + '")]'; 
		}
	}
}