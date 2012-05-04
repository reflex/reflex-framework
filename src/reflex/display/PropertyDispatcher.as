package reflex.display
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import reflex.events.DataChangeEvent;
	
	public class PropertyDispatcher extends EventDispatcher
	{
		
		public function PropertyDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		protected function notify(property:String, oldValue:*, newValue:*):void {
			var force:Boolean = false;
			var instance:IEventDispatcher = this;
			if(oldValue != newValue || force) {
				var eventType:String = property + "Change";
				if(instance is IEventDispatcher && (instance as IEventDispatcher).hasEventListener(eventType)) {
					var event:DataChangeEvent = new DataChangeEvent(eventType, oldValue, newValue);
					(instance as IEventDispatcher).dispatchEvent(event);
				}
			}
		}
		
	}
}