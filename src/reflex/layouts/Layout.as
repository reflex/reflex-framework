package reflex.layouts
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import reflex.binding.Bind;
	import reflex.data.NotifyingDispatcher;
	import reflex.invalidation.Invalidation;
	import reflex.metadata.resolveBindings;
	import reflex.metadata.resolveDataListeners;
	import reflex.metadata.resolveEventListeners;
	import reflex.metadata.resolveLayoutProperties;
	
	//[LayoutProperty(name="layout", measure="true")]
	//[LayoutProperty(name="measurements", measure="true")]
	/**
	 * The Layout class provides automated metadata handling for layouts which extend it.
	 * It is recommended that you extend this class to create custom layouts, but it's not required.
	 * 
	 * @alpha
	 **/
	public class Layout extends NotifyingDispatcher
	{
		
		private var attached:Dictionary = new Dictionary(true);
		private var _target:IEventDispatcher;
		
		[Bindable(event="targetChange")]
		public function get target():IEventDispatcher { return _target; }
		public function set target(value:IEventDispatcher):void
		{
			notify("target", _target, _target = value);
		}
		
		public function Layout() {
			reflex.metadata.resolveBindings(this);
			reflex.metadata.resolveEventListeners(this);
			reflex.metadata.resolveDataListeners(this);
			
			Bind.addListener(this, onInvalidateLayout, this, "target.width");
			Bind.addListener(this, onInvalidateLayout, this, "target.height");
		}
		
		public function measure(content:Array):Point {
			// this method of listening for layout invalidating changes is very much experimental
			for each(var child:IEventDispatcher in content) {
				if (attached[child] != true) {
					reflex.metadata.resolveLayoutProperties(this, child, onInvalidateLayout);
					attached[child] = true;
				}
			}
			return new Point(0, 0);
		}
		
		public function update(content:Array, tokens:Array, rectangle:Rectangle):Array {
			// this method of listening for layout invalidating changes is very much experimental
			for each(var child:Object in content) {
				if (child is IEventDispatcher && attached[child] != true) {
					reflex.metadata.resolveLayoutProperties(this, child as IEventDispatcher, onInvalidateLayout);
					attached[child] = true;
				}
			}
			return null;
		}
		
		private function onInvalidateLayout(object:*):void {
			if (target is DisplayObject) {
				Invalidation.invalidate(target as DisplayObject, "measure");
				Invalidation.invalidate(target as DisplayObject, "layout");
			}
		}
		
	}
}