package reflex.layouts
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import reflex.animation.AnimationToken;

	public class TileLayout extends Layout implements ILayout
	{
		
		private var columns:int = 3;
		public var gap:int = 10;
		
		override public function measure(content:Array):Point
		{
			var point:Point = super.measure(content);
			/*point.y = edging ? gap/2 : 0;
			for each(var child:Object in content) {
				var width:Number = reflex.measurement.resolveWidth(child);
				var height:Number = reflex.measurement.resolveHeight(child);
				point.x = Math.max(point.x, width);
				point.y += height + gap;
			}
			point.y -= edging ? gap/2 : gap;*/
			return point;
		}
		
		override public function update(content:Array, tokens:Array, rectangle:Rectangle):Array
		{
			super.update(content, tokens, rectangle);
			
			var point:Point = new Point(gap, gap);
			var length:int = content ? content.length : 0;
			for(var i:int = 0; i < length; i++) {
				var item:Object = content[i];
				var token:AnimationToken = tokens[i];
				token.x = point.x;
				token.y = point.y;
				if(token.x + token.width > rectangle.width) {
					point.x = gap;
					point.y += token.height + gap;
					token.x = point.x;
					token.y = point.y;
				}
				point.x += token.width + gap;
			}
			return tokens;
		}
		
	}
}