package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import flight.events.PropertyEvent;
	
	import reflex.events.RenderEvent;
	
	public class Layout extends EventDispatcher implements ILayout
	{
		public static const MEASURE:String = "measure";
		public static const LAYOUT:String = "layout";
		
		public static var layoutIndex:Dictionary = new Dictionary(true);
		public static function getLayout(key:DisplayObject):Layout
		{
			return layoutIndex[key];		// TODO: resolve the circular reference holding both display and Layout in memory
			var reference:Dictionary = layoutIndex[key];
			for (var i:* in reference) {
				return Layout(i);
			}
			return null;
		}
		
		private static var measurePhase:Boolean = RenderEvent.registerPhase(MEASURE, 0x80, false);
		private static var layoutPhase:Boolean = RenderEvent.registerPhase(LAYOUT, 0x40, true);
		
		[Bindable]
		public var freeform:Boolean = false;
		
		[Bindable]
		public var algorithm:ILayoutAlgorithm;
		
		private var validating:Boolean = false;
		private var reference:Dictionary = new Dictionary(true);
		
		private var _target:DisplayObject;
		
		public function Layout(target:DisplayObject = null)
		{
			reference[this] = true;		// used to maintain a weak-reference
			this.target = target;
		}
		
		[Bindable(event="targetChange")]
		public function get target():DisplayObject
		{
			return _target;
		}
		public function set target(value:DisplayObject):void
		{
			if (_target == value) {
				return;
			}
			
			if (_target != null) {
				_target.removeEventListener(MEASURE, onMeasure);
				_target.removeEventListener(LAYOUT, onLayout);
				delete layoutIndex[_target];
			}
			
			var oldValue:Object = _target;
			_target = value;
			
			if (_target != null) {
				_target.addEventListener(MEASURE, onMeasure, false, 0xF, true);
				_target.addEventListener(LAYOUT, onLayout, false, 0xF, true);
				if (layoutIndex[_target] != null) {
					getLayout(_target).target = null;
				}
				layoutIndex[_target] = this;//reference;
				
				invalidate(true);
				invalidate();
			}
			
			propertyChange("target", oldValue, _target);
		}
		
		public function invalidate(measure:Boolean = false):void
		{
			if (validating || _target == null) {
				return;
			}
			
			if (measure) {
				RenderEvent.invalidate(_target, MEASURE);
				return;
			}
			
			RenderEvent.invalidate(_target, LAYOUT);
			
			var parent:Layout = getLayout(_target.parent);
			if (parent != null ) {
				parent.invalidate(true);
			}
		}
		
		public function validate():void
		{
			if (validating || _target == null) {
				return;
			}
			validating = true;
			
			if (freeform) {
				layout();
			}
			
			if (algorithm != null && _target is DisplayObjectContainer) {
				algorithm.layout( DisplayObjectContainer(_target) );
			}
			
			validating = false;
		}
		
		public function layout():void
		{
		}
		
		public function measure():void
		{
			var container:DisplayObjectContainer = _target as DisplayObjectContainer;
			if (container == null) {
				return;
			}
			
			if (algorithm != null) {
				algorithm.measure(container);
			}
		}
		
		private function onLayout(event:Event):void
		{
			validate();
		}
		
		private function onMeasure(event:Event):void
		{
			measure();
		}
		
		// TODO: layouts and layouts (or layout-types) can choose what properties to listen to
		// on their children in order to invalidate (and choose which type of invalidation: layout or measure)
		protected function propertyChange(property:String, oldValue:Object, newValue:Object):void
		{
			if (_target != null && layoutIndex[_target.parent] is Layout) {
				var parent:Layout = layoutIndex[_target.parent];
				parent.childPropertyChange(property, oldValue, newValue);
			}
			
			PropertyEvent.dispatchChange(this, property, oldValue, newValue);
		}
		
		protected function childPropertyChange(property:String, oldValue:Object, newValue:Object):void
		{
		}
		
	}
}