package reflex.layouts
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import reflex.styles.resolveStyle;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	import reflex.measurement.setSize;
	import reflex.styles.hasStyle;
	
	[LayoutProperty(name="style.left", measure="true")]
	[LayoutProperty(name="style.right", measure="true")]
	[LayoutProperty(name="style.top", measure="true")]
	[LayoutProperty(name="style.bottom", measure="true")]
	[LayoutProperty(name="style.horizontalCenter", measure="true")]
	[LayoutProperty(name="style.verticalCenter", measure="true")]
	[LayoutProperty(name="width", measure="true")]
	[LayoutProperty(name="height", measure="true")]
	/**
	 * Recognizes style elements familiar to Flex developers such as left, right, top, bottom, horizontalCenter and verticalCenter.
	 * 
	 * @alpha
	 **/
	public class BasicLayout extends Layout implements ILayout
	{
		
		override public function measure(children:Array):Point
		{
			super.measure(children);
			var point:Point = new Point(0, 0);
			for each(var child:Object in children) {
				
				var width:Number = resolveWidth(child);
				var height:Number = resolveHeight(child);
				var left:Number = resolveStyle(child, "left") as Number;
				var right:Number = resolveStyle(child, "right") as Number;
				var top:Number = resolveStyle(child, "top") as Number;
				var bottom:Number = resolveStyle(child, "bottom") as Number;
				var horizontalCenter:Number = resolveStyle(child, "horizontalCenter") as Number;
				var verticalCenter:Number = resolveStyle(child, "verticalCenter") as Number;
				
				var xp:Number = child.x + width;
				var yp:Number = child.y + height;
				
				if(hasStyle(child, "left") && hasStyle(child, "right")) {
					xp = left + width + right;
				} else if(hasStyle(child, "left")) {
					xp = left + width;
				} else if(hasStyle(child, "right")) {
					xp = width + right;
				} else if(hasStyle(child, "horizontalCenter")) {
					xp = width + Math.abs(horizontalCenter);
				}
				
				if(hasStyle(child, "top") && hasStyle(child, "bottom")) {
					yp = top + height + bottom;
				} else if(hasStyle(child, "top")) {
					yp = top + height;
				} else if(hasStyle(child, "bottom")) {
					yp = height + bottom;
				} else if(hasStyle(child, "verticalCenter")) {
					yp = height + Math.abs(verticalCenter);
				}
				
				if(!isNaN(xp)) { point.x = Math.max(point.x, xp); }
				if(!isNaN(yp)) { point.y = Math.max(point.y, yp); }
			}
			return point;
		}
		
		override public function update(children:Array, rectangle:Rectangle):void
		{
			super.update(children, rectangle);
			for each(var child:Object in children) {
				var width:Number = resolveWidth(child);
				var height:Number = resolveHeight(child);
				var left:Number = resolveStyle(child, "left") as Number;
				var right:Number = resolveStyle(child, "right") as Number;
				var top:Number = resolveStyle(child, "top") as Number;
				var bottom:Number = resolveStyle(child, "bottom") as Number;
				var horizontalCenter:Number = resolveStyle(child, "horizontalCenter") as Number;
				var verticalCenter:Number = resolveStyle(child, "verticalCenter") as Number;
				
				if(hasStyle(child, "left") && hasStyle(child, "right")) {
					child.x = left;
					width = rectangle.width - child.x - right;
				} else if(hasStyle(child, "left")) {
					child.x = left;
				} else if(hasStyle(child, "right")) {
					child.x = rectangle.width - width - right;
				} else if(hasStyle(child, "horizontalCenter")) {
					child.x = rectangle.width/2 - width/2 + horizontalCenter;
				}
				
				if(hasStyle(child, "top") && hasStyle(child, "bottom")) {
					child.y = top;
					height = rectangle.height - child.y - bottom;
				} else if(hasStyle(child, "top")) {
					child.y = top;
				} else if(hasStyle(child, "bottom")) {
					child.y = rectangle.height - height - bottom;
				} else if(hasStyle(child, "verticalCenter")) {
					child.y = rectangle.height/2 - height/2 + verticalCenter;
				}
				
				reflex.measurement.setSize(child, width, height);
			}
		}
		
	}
}