package reflex.layouts
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import flight.binding.Bind;
	
	import reflex.events.InvalidationEvent;
	import reflex.metadata.resolveLayoutProperties;
	
	//[LayoutProperty(name="layout", measure="true")]
	//[LayoutProperty(name="measurements", measure="true")]
	public class Layout
	{
		
		private var attached:Dictionary = new Dictionary(true);
		
		[Bindable] public var target:IEventDispatcher;
		
		public function Layout() {
			Bind.addListener(this, onInvalidateLayout, this, "target.width");
			Bind.addListener(this, onInvalidateLayout, this, "target.height");
		}
		
		//public function measure(children:Array):Point { return null; }
		public function update(children:Array, rectangle:Rectangle):void {
			// this method of listening for layout invalidating changes is very much experimental
			for each(var child:IEventDispatcher in children) {
				if(attached[child] != true) {
					reflex.metadata.resolveLayoutProperties(this, child, onInvalidateLayout);
					attached[child] = true;
				}
			}
		}
		
		private function onInvalidateLayout(object:*):void {
			if(target is DisplayObject) {
				InvalidationEvent.invalidate(target as DisplayObject, "layout");
			}
		}
		
	}
}