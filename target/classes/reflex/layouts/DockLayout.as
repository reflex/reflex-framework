package reflex.layouts
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	import reflex.styles.resolveStyle;
	
	[LayoutProperty(name="style.dock", measure="true")]
	[LayoutProperty(name="width", measure="true")]
	[LayoutProperty(name="height", measure="true")]
	
	/**
	 * Provides a docking layout for common use cases which might otherwise require nested containers.
	 * 
	 * @alpha
	 */
	public class DockLayout extends Layout implements ILayout
	{
		
		static public const NONE:String = null;
		static public const LEFT:String = "left";
		static public const RIGHT:String = "right";
		static public const TOP:String = "top";
		static public const BOTTOM:String = "bottom";
		static public const FILL:String = "fill";
		static public const CENTER:String = "center";
		
		override public function measure(children:Array):Point
		{
			var point:Point = super.measure(children);
			var gap:Number = 5;
			point.x = gap;
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
			var length:int = children.length;
			for(var i:int = 0; i < length; i++) {
				var child:Object = children[i];
				var width:Number = reflex.measurement.resolveWidth(child);
				var height:Number = reflex.measurement.resolveHeight(child);
				var dock:String = reflex.styles.resolveStyle(child, "dock", null, NONE) as String;
				var align:String = reflex.styles.resolveStyle(child, "align", null, NONE) as String;
				switch (dock) {
					case LEFT :
						child.x = rectangle.x;
						child.y = rectangle.y;
						if (align == NONE) {
							child.setSize(width, rectangle.height);
						} else if (align == BOTTOM) {
							child.y = rectangle.y + rectangle.height - height;
						}
						break;
					case TOP :
						child.x = rectangle.x;
						child.y = rectangle.y;
						if (align == NONE) {
							child.setSize(rectangle.width, height)
						} else if (align == RIGHT) {
							child.x = rectangle.x + rectangle.width - width;
						}
						break;
					case RIGHT :
						child.x = rectangle.x + rectangle.width - width;
						child.y = rectangle.y;
						if (align == NONE) {
							child.setSize(width, rectangle.height);
						} else if (align == BOTTOM) {
							child.y = rectangle.y + rectangle.height - height;
						}
						break;
					case BOTTOM :
						child.x = rectangle.x;
						child.y = rectangle.y + rectangle.height - height;
						if (align == NONE) {
							child.setSize(rectangle.width, height);
						} else if (align == RIGHT) {
							child.x = rectangle.x + rectangle.width - width;
						}
						break;
					case FILL :
						child.x = rectangle.x;
						child.y = rectangle.y;
						child.setSize(rectangle.width, rectangle.height)
						break;
					case CENTER :
					default:
						child.x = rectangle.width/2 - width/2;
						child.y = rectangle.height/2 - height/2;
						break;
				}
			}
		}
		
	}
}