package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import reflex.core.Invalidator;

	public class Layout
	{
		public static const CONSTRAINT_PRIORITY:int = 2000;
		public static const LAYOUT_PRIORITY:int = 1000;
		
		public static var targetsLayouts:Dictionary = new Dictionary(true); 
		
		protected var _target:DisplayObjectContainer;
		
		
		public function Layout(target:DisplayObjectContainer = null)
		{
			this.target = target;
		}
		
		
		public function get target():DisplayObjectContainer
		{
			return _target;
		}
		
		public function set target(value:DisplayObjectContainer):void
		{
			if (_target == value) return;
			
			if (_target) {
				delete targetsLayouts[_target];
				_target.removeEventListener(Event.ADDED, onAdded);
			}
			
			_target = value;
			
			if (_target) {
				if (_target in targetsLayouts) {
					targetsLayouts[_target].target = null;
				}
				
				targetsLayouts[_target] = this;
				_target.addEventListener(Event.ADDED, onAdded);
				invalidate();
			}
		}
		
		
		public function layout():void
		{
			if (!_target) return;
			Invalidator.uninvalidate(_target, layout);
		}
		
		
		public function invalidate():void
		{
			if (_target) Invalidator.invalidate(_target, layout, LAYOUT_PRIORITY);
		}
		
		protected function onAdded(event:Event):void
		{
			var target:DisplayObject = event.target as DisplayObject;
			if (target.parent != _target) return;
			invalidate();
		}
	}
}