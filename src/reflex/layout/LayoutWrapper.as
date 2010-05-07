package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import flight.events.PropertyEvent;
	
	import reflex.events.InvalidationEvent;
	
	public class LayoutWrapper implements IEventDispatcher, ILayoutWrapper
	{
		public static const MEASURE:String = "measure";
		public static const LAYOUT:String = "layout";
		
		public static var layoutIndex:Dictionary = new Dictionary(true);
		public static function getLayout(key:DisplayObject):LayoutWrapper
		{
			return layoutIndex[key];		// TODO: resolve the circular reference holding both display and Layout in memory
			var reference:Dictionary = layoutIndex[key];
			for (var i:* in reference) {
				return LayoutWrapper(i);
			}
			return null;
		}
		
		private static var measurePhase:Boolean = InvalidationEvent.registerPhase(MEASURE, 0x80, false);
		private static var layoutPhase:Boolean = InvalidationEvent.registerPhase(LAYOUT, 0x40, true);
		
		[Bindable]
		public var freeform:Boolean = false;
		
		[Bindable]
		public var algorithm:ILayoutAlgorithm;
		
		[Bindable]
		public var shift:Number = 0;
		
		[Bindable]
		public var shiftSize:Number = 0;
		
		protected var dispatcher:IEventDispatcher;
		
		private var validating:Boolean = false;
		private var reference:Dictionary = new Dictionary(true);
		
		private var _target:DisplayObject;
		
		public function LayoutWrapper(target:DisplayObject = null)
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
			
			PropertyEvent.dispatchChange(this, "target", oldValue, _target);
		}
		
		public function invalidate(children:Boolean = false):void
		{
			if (validating || _target == null) {
				return;
			}
			
			InvalidationEvent.invalidate(_target, LAYOUT);
			
			if (children) {
				InvalidationEvent.invalidate(_target, MEASURE);
			} else {
				var parent:LayoutWrapper = getLayout(_target.parent);
				if (parent != null ) {
					parent.invalidate(true);
				}
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
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if (dispatcher == null) {
				dispatcher = new EventDispatcher(this);
			}
			
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			if (dispatcher != null) {
				dispatcher.removeEventListener(type, listener, useCapture);
			}
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			var result:Boolean = false;
			if (_target != null && _target.hasEventListener(event.type)) {
				result = _target.dispatchEvent(event);
			}
			if (dispatcher != null && dispatcher.hasEventListener(event.type)) {
				result = dispatcher.dispatchEvent(event);
			}
			return result;
		}
		
		public function hasEventListener(type:String):Boolean
		{
			if (dispatcher != null) {
				return dispatcher.hasEventListener(type);
			}
			return false;
		}
		
		public function willTrigger(type:String):Boolean
		{
			if (dispatcher != null) {
				return dispatcher.willTrigger(type);
			}
			return false;
		}
	}
}