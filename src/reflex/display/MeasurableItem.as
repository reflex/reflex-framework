package reflex.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import reflex.events.DataChangeEvent;
	import reflex.framework.IMeasurable;
	import reflex.framework.IMeasurablePercent;
	import reflex.framework.IStyleable;
	import reflex.injection.IReflexInjector;
	import reflex.invalidation.IReflexInvalidation;
	import reflex.invalidation.LifeCycle;
	import reflex.styles.Style;
	
	[Event(name="mouseOver", type="flash.events.MouseEvent")]
	[Event(name="mouseOut", type="flash.events.MouseEvent")]
	[Event(name="mouseDown", type="flash.events.MouseEvent")]
	[Event(name="mouseUp", type="flash.events.MouseEvent")]
	[Event(name="click", type="flash.events.MouseEvent")]
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	
	/**
	 * Provides explicit, implicit, and percent based measurement properties as well as a light-weight styling system.
	 * Although most display classes in Reflex extend Display, it's not referenced directly by the framework itself. 
	 * In other words, you are not required to extend this class to use Reflex!
	 * 
	 * @alpha
	 */
	public class MeasurableItem extends StyleableItem implements IMeasurable, IMeasurablePercent
	{
		
		include "../framework/MeasurableImplementation.as"; // measurement
		include "../framework/DisplayProxyImplementation.as"; // display proxy
		
		
		// invalidation & lifecycle
		
		private var _invalidation:IReflexInvalidation;
		
		//[Bindable]
		public var owner:Object; // Reflex Container
		
		private var _initialized:Boolean;
		public function get initialized():Boolean { return _initialized; }
		
		[Bindable(event="invalidationChange")]
		public function get invalidation():IReflexInvalidation { return _invalidation; }
		public function set invalidation(value:IReflexInvalidation):void {
			_invalidation = value;
		}
		
		public function MeasurableItem() {
			super();
			addEventListener(LifeCycle.INITIALIZE, initializeHandler);
			addEventListener(LifeCycle.COMMIT, commitHandler, false, 0, true);
			addEventListener(LifeCycle.MEASURE, measureHandler, false, 0, true);
			addEventListener(LifeCycle.LAYOUT, layoutHandler, false, 0, true);
		}
		
		
		public function invalidate(phase:String):void {
			if(_invalidation) { _invalidation.invalidate(this, phase); }
		}
		
		private function initializeHandler(event:Event):void {
			if(_initialized) { return; }
			_initialized = true;
			initialize();
		}
		
		private function commitHandler(event:Event):void {
			onCommit();
		}
		
		private function measureHandler(event:Event):void {
			onMeasure();
		}
		
		private function layoutHandler(event:Event):void {
			onLayout();
		}
		
		protected function initialize():void {
			_invalidation.invalidate(this, LifeCycle.COMMIT);
			_invalidation.invalidate(this, LifeCycle.MEASURE);
			_invalidation.invalidate(this, LifeCycle.LAYOUT);
		}
		
		protected function onCommit():void {
			
		}
		
		protected function onMeasure():void {
			
		}
		
		protected function onLayout():void {
			
		}
		
		public function validate():void {
			if(_invalidation) { _invalidation.validate(this); }
		}
		
	}
}