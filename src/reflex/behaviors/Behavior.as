package reflex.behaviors
{
	
	import flash.events.EventDispatcher;
	
	import flight.binding.Bind;
	import flight.utils.Type;
	
	import reflex.core.IBehavior;
	
	/**
	 * A base behavior class. Provides functionality for setting up listeners
	 * automatically with metadata.
	 */
	public class Behavior extends EventDispatcher implements IBehavior
	{
		
		protected namespace reflex = "http://reflex.io";
		
		private var _target:Object;
		
		public function Behavior()
		{
			describeEventListeners(this);
			describeAliases(this);
		}
		
		/**
		 * The object this behavior acts upon.
		 */
		[Bindable]
		public function get target():Object
		{
			return _target;
		}
		
		public function set target(value:Object):void
		{
			if (value == _target) return;
			_target = value;
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
					var path:String = listener.arg.(@key == "path").@value;
						path = "target" + (path ? "." + path : "");
					
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