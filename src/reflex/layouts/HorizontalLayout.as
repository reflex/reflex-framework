package reflex.layouts
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flight.binding.Bind;
	
	import reflex.events.InvalidationEvent;
	import reflex.measurement.getWidth;
	
	[LayoutProperty(name="style.grid")]
	[LayoutProperty(name="width", measure="true")]
	[LayoutProperty(name="height", measure="true")]
	public class HorizontalLayout extends Layout implements ILayout
	{
		
		public function measure(children:Array):Point
		{
			var gap:Number = 5;
			var point:Point = new Point(gap, 0);
			for each(var child:Object in children) {
				var width:Number = reflex.measurement.getWidth(child);
				var height:Number = reflex.measurement.getHeight(child);
				point.x += width + gap;
				point.y = Math.max(point.y, height);
			}
			return point;
		}
		
		public function update(children:Array, rectangle:Rectangle):void
		{
			var gap:Number = 5;
			var position:Number = gap;
			var length:int = children.length;
			for(var i:int = 0; i < length; i++) {
				var child:Object = children[i];
				var width:Number = reflex.measurement.getWidth(child);
				var height:Number = reflex.measurement.getHeight(child);
				child.x = position;
				child.y = rectangle.height/2 - height/2;
				position += width + gap;
			}
			attachBindings(children);
		}
		
		// update this for correct binding
		// find the easiest Flash/AS3 option (add metadata functionality as well)
		private function attachBindings(children:Array):void {
			for each(var child:IEventDispatcher in children) {
				Bind.addListener(child, onInvalidateMeasure, child, "width");
				Bind.addListener(child, onInvalidateMeasure, child, "height");
				Bind.addListener(child, onInvalidateMeasure, child, "measurements");
				Bind.addListener(child, onInvalidateMeasure, child, "layout");
			}
		}
		
		private function onInvalidateMeasure(object:*):void {
			if(target is DisplayObject) {
				InvalidationEvent.invalidate(target as DisplayObject, "measure");
			}
		}
		
	}
}