package reflex.behaviors
{
	
	import flash.display.InteractiveObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	
	import flight.binding.Bind;
	import flight.utils.Type;
	
	import reflex.metadata.resolveBindings;
	import reflex.metadata.resolveEventListeners;
	import reflex.metadata.resolvePropertyListeners;
	import reflex.skins.ISkinnable;
	
	/**
	 * Behavior is a convenient base class for various behavior implementations.
	 * These classes represent added features and functionality to a target
	 * InteractiveObject. Behavior takes advantage of the skin of an ISkinnable
	 * target by syncing skin parts and setting state.
	 * 
	 * Reflex component behaviors can be broken into 3 types -
	 * 1) a components single base behavior - core implementation with which the
	 * particular component would be useless without (eg ScrollBarBehavior)
	 * 2) a components addon behaviors - additional functionality specefic to
	 * the component (eg ReorderTabBehavior)
	 * 3) common addon behaviors - general solutions for all components, or all
	 * components of a type (eg TooltipBehavior)
	 * @alpha
	 */
	public class Behavior extends EventDispatcher implements IBehavior
	{
		
		private var _target:IEventDispatcher;
		
		/**
		 * The object this behavior acts upon.
		 */
		[Bindable(event="targetChange")]
		public function get target():IEventDispatcher { return _target; }
		public function set target(value:IEventDispatcher):void {
			_target = value;
			dispatchEvent(new Event("targetChange"));
		}
		
		// TODO: add SkinParts with support for adding child behaviors to them // bleh?
		// registration of Behavior instances (via styling?) for instantiation
		// skins ability to pull behavior data for state and other use
		// skins also need data such as labels and images? (localization?)
		// and dynamic data for it's content-area (component children)
		public function Behavior(target:IEventDispatcher = null)
		{
			this.target = target;
			reflex.metadata.resolveBindings(this);
			reflex.metadata.resolvePropertyListeners(this);
			reflex.metadata.resolveEventListeners(this);
		}
		
		protected function getSkinPart(part:String):InteractiveObject
		{
			if (target is ISkinnable && ISkinnable(target).skin != null) {
				return ISkinnable(target).skin.getSkinPart(part) as InteractiveObject;
			} else if (part in target) {
				return target[part] as InteractiveObject;
			} else {
				return null;
			}
		}
		
	}
}