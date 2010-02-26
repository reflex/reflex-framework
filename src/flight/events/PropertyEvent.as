package flight.events
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	
	public class PropertyEvent extends PropertyChangeEvent
	{
		public static const CHANGE:String = "Change";
		
		public static function dispatchChange(source:IEventDispatcher, property:Object, oldValue:Object, newValue:Object):void
		{
			if ( source.hasEventListener(property + CHANGE) ) {
				var event:PropertyEvent = new PropertyEvent(property + CHANGE, property, oldValue, newValue);
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
		
		
		private static var changes:Dictionary = new Dictionary(true);
		public static function change(source:IEventDispatcher, property:Object, oldValue:*, newValue:*):*
		{
			if (oldValue === newValue) {
				return newValue;
			}
			
			var change:Change = Change.getChange();
			change.property = property;
			change.oldValue = oldValue;
			change.newValue = newValue;
			
			if (changes[source] != null) {
				change.next = changes[source];
			}
			changes[source] = change;
			return newValue;
		}
		
		public static function dispatch(source:IEventDispatcher):void
		{
			var change:Change = changes[source];
			delete changes[source];
			
			while (change != null) {
				if (source.hasEventListener(change.property + CHANGE)) {
					source.dispatchEvent( new PropertyEvent(change.property + CHANGE, change.property, change.oldValue, change.newValue) );
				}
				change = Change.nextChange(change);
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

class Change
{
	public var property:Object;
	public var oldValue:*;
	public var newValue:*;
	
	public var next:Change;
	
	
	private static var cache:Change;
	public static function getChange():Change
	{
		var change:Change;
		if (cache == null) {
			change = new Change();
		} else {
			change = cache;
			cache = change.next;
			change.next = null;
		}
		
		return change;
	}
	
	public static function nextChange(change:Change):Change
	{
		var next:Change = change.next;
		change.next = cache;
		cache = change;
		return next;
	}
}
