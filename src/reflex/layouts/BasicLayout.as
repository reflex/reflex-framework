package reflex.layouts
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import reflex.animation.AnimationToken;
	import reflex.graphics.IGraphicItem;
	import reflex.graphics.Line;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	import reflex.measurement.setSize;
	import reflex.styles.hasStyle;
	import reflex.styles.resolveStyle;
	
	[LayoutProperty(name="style.left", measure="true")]
	[LayoutProperty(name="style.right", measure="true")]
	[LayoutProperty(name="style.top", measure="true")]
	[LayoutProperty(name="style.bottom", measure="true")]
	[LayoutProperty(name="style.horizontalCenter", measure="true")]
	[LayoutProperty(name="style.verticalCenter", measure="true")]
	[LayoutProperty(name="horizontalCenter", measure="true")]
	[LayoutProperty(name="width", measure="true")]
	[LayoutProperty(name="height", measure="true")]
	/**
	 * Recognizes style elements familiar to Flex developers such as left, right, top, bottom, horizontalCenter and verticalCenter.
	 * 
	 * @alpha
	 **/
	public class BasicLayout extends Layout implements ILayout
	{
		
		override public function measure(content:Array):Point
		{
			var point:Point = super.measure(content);
			for each(var child:Object in content) {
				
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
		
		override public function update(content:Array, tokens:Array, rectangle:Rectangle):Array
		{
			super.update(content, tokens, rectangle);
			
			var length:int = content ? content.length : 0;
			for(var i:int = 0; i < length; i++) {
				var child:Object = content[i];
				var token:AnimationToken = tokens[i];
				if(token == null) { return []; }
				var width:Number = resolveWidth(child, rectangle.width);
				var height:Number = resolveHeight(child, rectangle.height);
				var left:Number = resolveStyle(child, "left") as Number;
				var right:Number = resolveStyle(child, "right") as Number;
				var top:Number = resolveStyle(child, "top") as Number;
				var bottom:Number = resolveStyle(child, "bottom") as Number;
				var horizontalCenter:Number = resolveStyle(child, "horizontalCenter") as Number;
				var verticalCenter:Number = resolveStyle(child, "verticalCenter") as Number;
				
				if(hasStyle(child, "left") && hasStyle(child, "right")) {
					token.x = Math.round(left);
					width = rectangle.width - token.x - right;
				} else if(hasStyle(child, "left")) {
					token.x = Math.round(left);
				} else if(hasStyle(child, "right")) {
					token.x = Math.round(rectangle.width - width - right);
				} else if(hasStyle(child, "horizontalCenter")) {
					token.x = Math.round(rectangle.width/2 - width/2 + horizontalCenter);
				}
				
				if(hasStyle(child, "top") && hasStyle(child, "bottom")) {
					token.y = Math.round(top);
					height = rectangle.height - token.y - bottom;
				} else if(hasStyle(child, "top")) {
					token.y = Math.round(top);
				} else if(hasStyle(child, "bottom")) {
					token.y = Math.round(rectangle.height - height - bottom);
				} else if(hasStyle(child, "verticalCenter")) {
					token.y = Math.round(rectangle.height/2 - height/2 + verticalCenter);
				}
				
				if(width > 0 && height > 0) { // for shapes which haven't been drawn to yet
					//reflex.measurement.setSize(child, Math.round(width), Math.round(height));
					token.width = Math.round(width);
					token.height = Math.round(height);
				} else if(child is IGraphicItem) { // sometime width/height is 0 for lines
					//reflex.measurement.setSize(child, Math.round(width), Math.round(height));
					token.width = Math.round(width);
					token.height = Math.round(height);
					/*
					if(width == 0) { width = (child as Line).stroke.weight; }
					if(height == 0) { height = (child as Line).stroke.weight; }
					reflex.measurement.setSize(child, Math.round(width), Math.round(height));
					*/
				}
			}
			return tokens;
		}
		
	}
}