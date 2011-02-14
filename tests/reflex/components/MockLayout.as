package reflex.components {
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import reflex.layouts.ILayout;
	
	public class MockLayout implements ILayout {
		private var _target:IEventDispatcher;

		public function MockLayout() {
		}
		
		public function get target():IEventDispatcher { return _target; }
		public function set target(value:IEventDispatcher):void {
			_target = value;
		}
		
		public function measure(children:Array):Point {
			return null;
		}

		public function update(children:Array, rectangle:Rectangle):void {
		}
	}
}