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
			addEventListener(LifeCycle.INITIALIZE, initialize);
			addEventListener(LifeCycle.INVALIDATE, commit, false, 0, true);
			addEventListener(LifeCycle.MEASURE, onMeasure, false, 0, true);
			addEventListener(LifeCycle.LAYOUT, onLayout, false, 0, true);
		}
		
		public function invalidate(phase:String):void {
			if(_invalidation) { _invalidation.invalidate(this, phase); }
		}
		
		protected function initialize(event:Event):void {
			if(_initialized) { return; }
			_initialized = true;
			
			_invalidation.invalidate(this, LifeCycle.INVALIDATE);
			_invalidation.invalidate(this, LifeCycle.MEASURE);
			_invalidation.invalidate(this, LifeCycle.LAYOUT);
			//commit(null);
		}
		
		protected function commit(event:Event):void {
			
		}
		
		protected function onMeasure(event:Event):void {
			
		}
		
		protected function onLayout(event:Event):void {
			
		}
		
		public function validate():void {
			if(_invalidation) { _invalidation.validate(this); }
		}
		
	}
}