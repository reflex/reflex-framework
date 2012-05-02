package reflex.layouts
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import reflex.animation.AnimationToken;
	import reflex.measurement.calculateAvailableSpace;
	import reflex.measurement.calculatePercentageTotals;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	import reflex.measurement.setSize;
	import reflex.styles.resolveStyle;
		
	[LayoutProperty(name="width", measure="true")]
	[LayoutProperty(name="height", measure="true")]
	
	/**
	 * Provides a measured layout from left to right.
	 * 
	 * @alpha
	 **/
	public class HorizontalLayout extends Layout implements ILayout
	{
		
		public var gap:Number = 5;
		public var edging:Boolean = false;
		public var verticalAlign:String = "top"; // bottom, middle, top, justify
		public var horizontalAlign:String = "left"; // left, center, right
		
		public function HorizontalLayout(gap:Number = 5, verticalAlign:String = "top", edging:Boolean = false):void {
			super();
			this.gap = gap;
			this.verticalAlign = verticalAlign;
			this.edging = edging;
		}
		
		override public function measure(content:Array):Point
		{
			var point:Point = super.measure(content);
			point.x = edging ? gap/2 : 0;
			for each(var child:Object in content) {
				var width:Number = reflex.measurement.resolveWidth(child);
				var height:Number = reflex.measurement.resolveHeight(child);
				point.x += width + gap;
				point.y = Math.max(point.y, height);
			}
			point.x -= edging ? gap/2 : gap;
			return point;
		}
		
		override public function update(content:Array, tokens:Array, rectangle:Rectangle):Array
		{
			super.update(content, tokens, rectangle);
			if(content) {
				
				var gap:Number = reflex.styles.resolveStyle(target, "gap", null, this.gap) as Number;
				var verticalAlign:String = reflex.styles.resolveStyle(target, "verticalAlign", null, this.verticalAlign) as String;
				
				// this takes a few passes for percent-based measurement. we can probably speed it up later
				var availableSpace:Point = reflex.measurement.calculateAvailableSpace(content, rectangle);
				var percentageTotals:Point = reflex.measurement.calculatePercentageTotals(content);
				
				var position:Number = edging ? gap/2 : 0;
				var length:int = content.length;
				
				availableSpace.x -= edging ? gap*length : gap*(length-1);
				for(var i:int = 0; i < length; i++) {
					var child:Object = content[i];
					var token:AnimationToken = tokens[i];
					var width:Number = reflex.measurement.resolveWidth(token, availableSpace.x, percentageTotals.x);  // calculate percentWidths based on available width and normalized percentages
					var height:Number = reflex.measurement.resolveHeight(token, rectangle.height); // calculate percentHeights based on full height and with no normalization
                    if(verticalAlign == "justify")
                        height = rectangle.height;
					
					token.x = Math.round(position);
					
					switch(verticalAlign) {
						case "middle":
						case "center":
							token.y = Math.round(rectangle.height/2 - height/2);
							break;
						case "top":
						case "justify":
							token.y = 0;
							break;
						case "bottom":
							token.y = Math.round(rectangle.height - height);
							break;
					}
					//child.y = Math.round(rectangle.height/2 - height/2);
					//reflex.measurement.setSize(child, Math.round(width), Math.round(height));
					token.width = Math.round(width);
					token.height = Math.round(height);
					position += width + gap;
				}
			}
			return tokens;
		}
		
	}
}