package reflex.layouts
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import reflex.measurement.resolveWidth;
	import reflex.measurement.resolveHeight;
		
	[LayoutProperty(name="width", measure="true")]
	[LayoutProperty(name="height", measure="true")]
	
	/**
	 * Provides a measured layout from left to right.
	 * 
	 * @alpha
	 **/
	public class HorizontalLayout extends Layout implements ILayout
	{
		
		[Bindable] public var gap:Number = 5;
		
		override public function measure(children:Array):Point
		{
			super.measure(children);
			var point:Point = new Point(gap, 0);
			for each(var child:Object in children) {
				var width:Number = reflex.measurement.resolveWidth(child);
				var height:Number = reflex.measurement.resolveHeight(child);
				point.x += width + gap;
				point.y = Math.max(point.y, height);
			}
			return point;
		}
		
		override public function update(children:Array, rectangle:Rectangle):void
		{
			super.update(children, rectangle);
			var position:Number = gap;
			var length:int = children.length;
			for(var i:int = 0; i < length; i++) {
				var child:Object = children[i];
				var width:Number = reflex.measurement.resolveWidth(child);
				var height:Number = reflex.measurement.resolveHeight(child);
				child.x = position;
				child.y = rectangle.height/2 - height/2;
				position += width + gap;
			}
		}
		
	}
}