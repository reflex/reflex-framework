package reflex.layouts
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	import reflex.measurement.setSize;
	
	//[LayoutProperty(name="width")]
	//[LayoutProperty(name="height")]
	public class CircleLayout extends Layout implements ILayout
	{
		
		[Bindable] public var rotate:Boolean;
		
		override public function measure(children:Array):Point
		{
			super.measure(children);
			var point:Point = new Point(0, 0);
			for each(var child:Object in children) {
				var width:Number = reflex.measurement.resolveWidth(child);
				var height:Number = reflex.measurement.resolveHeight(child);
				//point.x += width; // just guessing for now
				//point.y += height;
				point.x = 500;
				point.y = 500;
			}
			//point.x = (point.x + point.y)/2;
			//point.y = point.x;
			return point;
		}
		
		override public function update(children:Array, rectangle:Rectangle):void
		{
			super.update(children, rectangle);
			if(children) {
				 var length:int = children.length;
				 var offset:Number = 180*(Math.PI/180); // ?
				 for (var i:int = 0; i < length; i++) {
					var child:DisplayObject = children[i];
					var childWidth:Number = reflex.measurement.resolveWidth(child);
					var childHeight:Number = reflex.measurement.resolveHeight(child);
					var width:Number = rectangle.width/2 - childWidth;
					var height:Number = rectangle.height/2 - childHeight;
					var rad:Number = ((Math.PI*i)/(length/2))+offset;
					
					child.x = Math.round((width*Math.cos(rad))+width) + childWidth/2;
					child.y = Math.round((height*Math.sin(rad))+height) + childHeight/2;
					//reflex.measurement.setSize(child, childWidth, childHeight);
					if(rotate) {
						child.rotationZ = ((360/length)*i);
						while(child.rotationZ > 180) {
							child.rotationZ -= 360;
						}
					}
				 }
			}
			
		}
		
	}
}