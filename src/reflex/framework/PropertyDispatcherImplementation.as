import flash.events.IEventDispatcher;

import reflex.events.DataChangeEvent;

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