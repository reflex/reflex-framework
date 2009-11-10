package flight.events
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	
	public class PropertyEvent extends PropertyChangeEvent
	{
		public static const PROPERTY_CHANGE:String = "propertyChange";
		
		public static const CHANGE:String = "Change";
		
		public static function dispatchChange(source:IEventDispatcher, property:Object, oldValue:Object, newValue:Object):void
		{
			var event:PropertyEvent;
			
			if ( source.hasEventListener(property + CHANGE) ) {
				event = new PropertyEvent(property + CHANGE, property, oldValue, newValue);
				source.dispatchEvent(event);
			}
			
			if ( source.hasEventListener(PROPERTY_CHANGE) ) {
				event = new PropertyEvent(PROPERTY_CHANGE, property, oldValue, newValue);
				source.dispatchEvent(event);
			}
		}
		
		public static function dispatchChangeList(target:IEventDispatcher, properties:Array, oldValues:Array):void
		{
			for (var i:int = 0; i < properties.length; i++) {
				var property:Object = properties[i];
				var oldValue:Object = oldValues[i];
				var newValue:Object = target[property];
				if (oldValue != newValue || newValue is Array) {
			 		dispatchChange(target, property, oldValue, newValue);
			 	}
	 		}
		}
		
		public function PropertyEvent(type:String, property:Object, oldValue:Object, newValue:Object)
		{
			super(type, false, false, PropertyChangeEventKind.UPDATE, property, oldValue, newValue);
		}
		
		override public function clone():Event
		{
			return new PropertyEvent(type, property, oldValue, newValue);
		}
	}
}