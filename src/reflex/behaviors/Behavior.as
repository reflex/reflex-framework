package reflex.behaviors
{
	
	import flash.display.InteractiveObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
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
		/**
		 * The object this behavior acts upon.
		 */
		[Bindable]
		public var target:IEventDispatcher;
		
		// TODO: add SkinParts with support for adding child behaviors to them
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
		/*
		protected function bindProperty(target:String, source:String):void
		{
			Bind.addBinding(this, target, this, source, true);
		}
		
		protected function bindPropertyListener(target:String, listener:Function):void
		{
			Bind.addListener(this, listener, this, target);
		}
		
		protected function bindEventListener(type:String, target:String, listener:Function,
											 useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			Bind.bindEventListener(type, listener, this, target, useCapture, priority, useWeakReference);
		}
		*/
		/*
		// parses [Binding(target="target.path")] metadata
		public static function describeBindings(behavior:IBehavior):void
		{
			var desc:XMLList = Type.describeProperties(behavior, "Binding");
			
			for each (var prop:XML in desc) {
				var meta:XMLList = prop.metadata.(@name == "Binding");
				
				// to support multiple Binding metadata tags on a single property
				for each (var tag:XML in meta) {
					var targ:String = ( tag.arg.(@key == "target").length() > 0 ) ?
										tag.arg.(@key == "target").@value :
										tag.arg.@value;
					
					Bind.addBinding(behavior, targ, behavior, prop.@name, true);
				}
			}
		}
		
		// parses [PropertyListener(target="target.path)] metadata
		public static function describePropertyListeners(behavior:IBehavior):void
		{
			var desc:XMLList = Type.describeMethods(behavior, "PropertyListener");
			
			for each (var meth:XML in desc) {
				var meta:XMLList = meth.metadata.(@name == "PropertyListener");
				
				// to support multiple PropertyListener metadata tags on a single method
				for each (var tag:XML in meta) {
					var targ:String = ( tag.arg.(@key == "target").length() > 0 ) ?
										tag.arg.(@key == "target").@value :
										tag.arg.@value;
					
					Bind.addListener(behavior as IEventDispatcher, behavior[meth.@name], behavior, targ);
				}
			}
		}
		
		// parses [EventListener(type="eventType", target="target.path")] metadata
		public static function describeEventListeners(behavior:IBehavior):void
		{
			var desc:XMLList = Type.describeMethods(behavior, "EventListener");
			
			for each (var meth:XML in desc) {
				var meta:XMLList = meth.metadata.(@name == "EventListener");
				
				// to support multiple EventListener metadata tags on a single method
				for each (var tag:XML in meta) {
					var type:String = ( tag.arg.(@key == "type").length() > 0 ) ?
										tag.arg.(@key == "type").@value :
										tag.arg.@value;
					var targ:String = tag.arg.(@key == "target").@value;
					
					Bind.bindEventListener(type, behavior[meth.@name], behavior, targ);
				}
			}
		}
		*/
	}
}