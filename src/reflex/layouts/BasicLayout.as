package reflex.layouts
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flight.binding.Bind;
	
	import reflex.styles.resolveStyle;
	import reflex.events.InvalidationEvent;
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
	 * @alpha
	 **/
	public class BasicLayout extends Layout implements ILayout
	{
		
		override public function measure(children:Array):Point
		{
			super.measure(children);
			var point:Point = new Point(0, 0);
			for each(var item:Object in children) {
				var xp:Number = item.x + resolveWidth(item);
				var yp:Number = item.y + resolveHeight(item);
				if(!isNaN(xp)) { point.x = Math.max(point.x, xp); }
				if(!isNaN(yp)) { point.y = Math.max(point.y, yp); }
			}
			return point;
		}
		
		override public function update(children:Array, rectangle:Rectangle):void
		{
			super.update(children, rectangle);
			for each(var child:Object in children) {
				var width:Number = reflex.measurement.resolveWidth(child);
				var height:Number = reflex.measurement.resolveHeight(child);
				var left:Number = reflex.styles.resolveStyle(child, "left") as Number;
				var right:Number = reflex.styles.resolveStyle(child, "right") as Number;
				var top:Number = reflex.styles.resolveStyle(child, "top") as Number;
				var bottom:Number = reflex.styles.resolveStyle(child, "bottom") as Number;
				var horizontalCenter:Number = reflex.styles.resolveStyle(child, "horizontalCenter") as Number;
				var verticalCenter:Number = reflex.styles.resolveStyle(child, "verticalCenter") as Number;
				
				if(hasStyle(child, "left") && hasStyle(child, "right")) {
					child.x = left;
					width = rectangle.width - child.x - right;
				} else if(hasStyle(child, "left")) {
					child.x = reflex.styles.resolveStyle(child, "left") as Number;
				} else if(hasStyle(child, "right")) {
					child.x = rectangle.width - width - right;
				} else if(hasStyle(child, "horizontalCenter")) {
					child.x = rectangle.width/2 - width/2;
				}
				
				if(hasStyle(child, "top") && hasStyle(child, "bottom")) {
					child.y = top;
					height = rectangle.height - child.y - bottom;
				} else if(hasStyle(child, "top")) {
					child.y = top;
				} else if(hasStyle(child, "bottom")) {
					child.y = rectangle.height - height - bottom;
				} else if(hasStyle(child, "verticalCenter")) {
					child.y = rectangle.height/2 - height/2;
				}
				
				reflex.measurement.setSize(child, width, height);
			}
		}
		
	}
}