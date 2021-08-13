package reflex.animation
{
	public dynamic class AnimationToken
	{
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public var width:Number;
		public var height:Number;
		
		public var rotationX:Number = 0;
		public var rotationY:Number = 0;
		public var rotationZ:Number = 0;
		
		//public var alpha:Number = 1.0;
		
		public function AnimationToken(x:Number, y:Number, width:Number, height:Number)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
	}
}