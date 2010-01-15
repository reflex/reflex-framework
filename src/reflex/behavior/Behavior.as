package reflex.behavior
{
	
	import flash.display.InteractiveObject;
	import flash.events.EventDispatcher;
	
	import flight.binding.Bind;
	import flight.utils.Type;
	
	import reflex.core.IBehavior;
	import reflex.core.ISkinnable;
	
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
	 */
	public class Behavior extends EventDispatcher implements IBehavior
	{
		public function Behavior(target:InteractiveObject = null)
		{
			describeEventListeners(this);
			describeAliases(this);
			if (target != null) {
				this.target = target;
			}
		}
		
		/**
		 * The object this behavior acts upon.
		 */
		[Bindable]
		public var target:InteractiveObject;
		
		protected function getSkinPart(part:String):InteractiveObject
		{
			if (target is ISkinnable) {
				return ISkinnable(target).skin.getSkinPart(part) as InteractiveObject;
			} else if (part in target) {
				return target[part] as InteractiveObject;
			} else {
				return null;
			}
		}
		
		// parses [EventListener(type="eventType", path="optionalPath")] metadata
		// and binds EventListeners in one concise method
		public static function describeEventListeners(behavior:IBehavior):void
		{
			var desc:XMLList = Type.describeMethods(behavior, "EventListener");
			
			for each (var meth:XML in desc) {
				var method:String = meth.@name;
				var eventListener:XMLList = meth.metadata.(@name == "EventListener");
				
				// to support multiple EventListener metadata tags on a single method
				for each (var listener:XML in eventListener) {
					var type:String = (listener.arg.(@key == "type").length() > 0) ?
									   listener.arg.(@key == "type").@value :
									   listener.arg.@value;
					var path:String = listener.arg.(@key == "target").@value;
					
					Bind.bindEventListener(type, behavior[method], behavior, path);
				}
			}
		}
		
		public static function describeAliases(behavior:IBehavior):void
		{
			var desc:XMLList = Type.describeProperties(behavior, "Alias");
			
			for each (var prop:XML in desc) {
				var property:String = prop.@name;
				Bind.addBinding(behavior, property, behavior, "target");
			}
		}
		
	}
}