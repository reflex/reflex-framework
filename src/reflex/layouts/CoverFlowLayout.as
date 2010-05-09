package reflex.layouts
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flight.binding.Bind;
	
	[LayoutProperty(name="width", measure="true")]
	[LayoutProperty(name="height", measure="true")]
	public class CoverFlowLayout extends Layout implements ILayout
	{
		
		public function measure(children:Array):Point
		{
			var gap:Number = 5;
			var point:Point = new Point(gap, 0);
			for each(var item:Object in children) {
				point.x += item.width + gap;
				
			}
			return point;
		}
		
		override public function update(children:Array, rectangle:Rectangle):void
		{
			var gap:Number = 5;
			var position:Number = gap + 500;
			var length:int = children.length;
			for(var i:int = 0; i < length; i++) {
				var child:Object = children[i];
				child.x = position;
				child.y = 300;
				child.rotationY = 60;
				position += 10 + gap;
			}
		}
		
	}
}