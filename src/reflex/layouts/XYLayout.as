package reflex.layouts
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flight.binding.Bind;
	
	import reflex.events.InvalidationEvent;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	
	[LayoutProperty(name="x", measure="true")]
	[LayoutProperty(name="y", measure="true")]
	[LayoutProperty(name="width", measure="true")]
	[LayoutProperty(name="height", measure="true")]
	
	/**
	 * @alpha
	 **/
	public class XYLayout extends Layout implements ILayout
	{
		
		
		override public function measure(children:Array):Point
		{
			var point:Point = new Point(0, 0);
			for each(var item:Object in children) {
				var xp:Number = item.x + resolveWidth(item);
				var yp:Number = item.y + resolveHeight(item);
				point.x = Math.max(point.x, xp);
				point.y = Math.max(point.y, yp);
			}
			//attachBindings(children);
			return point;
		}
		
		override public function update(children:Array, rectangle:Rectangle):void
		{
			attachBindings(children);
		}
		
		// update this for correct binding
		// find the easiest Flash/AS3 option (add metadata functionality as well)
		private function attachBindings(children:Array):void {
			for each(var child:IEventDispatcher in children) {
				Bind.addListener(child, onInvalidateMeasure, child, "x");
				Bind.addListener(child, onInvalidateMeasure, child, "y");
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