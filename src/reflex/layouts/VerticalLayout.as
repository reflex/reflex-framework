package reflex.layouts
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import reflex.measurement.IMeasurablePercent;
	import reflex.measurement.calculateAvailableSpace;
	import reflex.measurement.calculatePercentageTotals;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	import reflex.measurement.setSize;
	import reflex.styles.resolveStyle;
	
	[LayoutProperty(name="width", measure="true")]
	[LayoutProperty(name="height", measure="true")]
	
	/**
	 * Provides a measured layout from top to bottom.
	 * 
	 * @alpha
	 **/
	public class VerticalLayout extends Layout implements ILayout
	{
		
		// not sure where these constants will go yet, use string for now
		//static public const ALIGN_LEFT:String = "left";
		//static public const ALIGN_RIGHT:String = "right";
		//static public const ALIGN_CENTER:String = "center";
		//static public const ALIGN_JUSTIFY:String = "justify";

		public var gap:Number = 5;
		public var edging:Boolean = false;
		public var horizontalAlign:String = "left";
		
		public function VerticalLayout(gap:Number = 5, horizontalAlign:String = "top", edging:Boolean = false):void {
			super();
			this.gap = gap;
			this.horizontalAlign = horizontalAlign;
			this.edging = edging;
		}
		
		override public function measure(content:Array):Point
		{
			var point:Point = super.measure(content);
			point.y = edging ? gap/2 : 0;
			for each(var child:Object in content) {
				var width:Number = reflex.measurement.resolveWidth(child);
				var height:Number = reflex.measurement.resolveHeight(child);
				point.x = Math.max(point.x, width);
				point.y += height + gap;
			}
			point.y -= edging ? gap/2 : gap;
			return point;
		}
		
		override public function update(content:Array, tokens:Array, rectangle:Rectangle):void
		{
			super.update(content, tokens, rectangle);
			if(content) {
				
				// some style-binding might take care of this later
				var gap:Number = reflex.styles.resolveStyle(target, "gap", Number, this.gap) as Number;
				var horizontalAlign:String = reflex.styles.resolveStyle(target, "horizontalAlign", String, this.horizontalAlign) as String;
				
				// this takes a few passes for percent-based measurement. we can probably speed it up later
				var availableSpace:Point = reflex.measurement.calculateAvailableSpace(content, rectangle);
				var percentageTotals:Point = reflex.measurement.calculatePercentageTotals(content);
				
				
				var position:Number = edging ? gap/2 : 0;
				var length:int = content.length;
				
				availableSpace.y -= edging ? gap*length : gap*(length-1);
				for(var i:int = 0; i < length; i++) {
					var child:Object = content[i];
					var width:Number = reflex.measurement.resolveWidth(child, rectangle.width); // calculate percentWidths based on full width and with no normalization
					if(horizontalAlign == "justify")
                        width = rectangle.width;
					var height:Number = reflex.measurement.resolveHeight(child, availableSpace.y, percentageTotals.y);  // calculate percentHeights based on available height and normalized percentages
					reflex.measurement.setSize(child, Math.round(width), Math.round(height));
					
					switch(horizontalAlign) {
						case "center":
						case "middle":
							child.x = Math.round(rectangle.width/2 - width/2);
							break;
						case "justify":
						case "left":
							child.x = 0;
							break;
						case "right":
							child.x = Math.round(rectangle.width - width);
							break;
					}
					//child.x = Math.round(rectangle.width/2 - width/2);
					child.y = Math.round(position);
					position += height + gap;
				}
			}
		}
		
	}
}