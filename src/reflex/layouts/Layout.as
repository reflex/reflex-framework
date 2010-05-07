package reflex.layouts
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	import flight.binding.Bind;
	
	import reflex.events.InvalidationEvent;
	
	[LayoutProperty(name="layout", measure="true")]
	public class Layout
	{
		
		[Bindable] public var target:IEventDispatcher;
		
		public function Layout() {
			Bind.addListener(this, onInvalidateLayout, this, "target.width");
			Bind.addListener(this, onInvalidateLayout, this, "target.height");
		}
		
		private function onInvalidateLayout(object:*):void {
			if(target is DisplayObject) {
				InvalidationEvent.invalidate(target as DisplayObject, "layout");
			}
		}
		
	}
}