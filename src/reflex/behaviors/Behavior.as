package reflex.behaviors
{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import reflex.display.PropertyDispatcher;
	import reflex.events.DataChangeEvent;
	import reflex.metadata.resolveBindings;
	import reflex.metadata.resolveDataListeners;
	import reflex.metadata.resolveEventListeners;
	
	/**
	 * Behavior is a convenient base class for various behavior implementations.
	 * These classes represent added features and functionality to a target
	 * InteractiveObject. Behavior takes advantage of the skin of an ISkinnable
	 * target by syncing skin parts and setting state.
	 * 
	 * @alpha
	 */
	public class Behavior extends PropertyDispatcher implements IBehavior
	{
		
		private var _target:IEventDispatcher;
		
		/**
		 * The object this behavior acts upon.
		 */
		[Bindable(event="targetChange")]
		public function get target():IEventDispatcher { return _target; }
		public function set target(value:IEventDispatcher):void {
			notify("target", _target, _target = value);
		}
		
		
		public function Behavior(target:IEventDispatcher = null)
		{
			super(this);
			_target = target;
			reflex.metadata.resolveBindings(this);
			reflex.metadata.resolveDataListeners(this);
			reflex.metadata.resolveEventListeners(this);
		}
		
	}
}