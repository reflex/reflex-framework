/*
 * Copyright (c) 2009-2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package reflex.binding
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import reflex.events.DataChangeEvent;
	
	/**
	 * DataChange enables objects to broadcast when their properties change
	 * value, allowing property watchers and data binding.
	 */
	public class DataChange 
	{
		
		internal static var staticCallbacks:Vector.<Function> = new Vector.<Function>();
		/*
		private static var headChange:Object = {};
		private static var currentChanges:DataChange;
		private static var objectPool:DataChange;
		*/
		/**
		 * The more concise approach to notifying a change in data when only a
		 * single value is updated.
		 */
		public static function change(source:Object, property:String, oldValue:*, newValue:*, force:Boolean = false):void
		{
			if(oldValue != newValue || force) {
				var eventType:String = property + "Change";
				if(source is IEventDispatcher && (source as IEventDispatcher).hasEventListener(eventType)) {
					var event:DataChangeEvent = new DataChangeEvent(eventType, oldValue, newValue);
					(source as IEventDispatcher).dispatchEvent(event);
				}
			}
			//queueChange(source, property, oldValue, newValue, force);
			//completeChange(source, property);
		}
		/*
		public static function queueChange(source:Object, property:String, oldValue:*, newValue:*, force:Boolean = false):DataChange
		{
			var dataChange:DataChange;
			
			// pull DataChange object from the object pool if available
			if (objectPool) {
				dataChange = objectPool;
				objectPool = dataChange.next;
			} else {
				dataChange = new DataChange();
			}
			
			// assign change values
			dataChange.source = source;
			dataChange.property = property;
			dataChange.oldValue = oldValue;
			dataChange.newValue = newValue;
			dataChange.force = force;
			
			// capture the head change
			if (!currentChanges) {
				headChange[property] = source;
			}
			
			// add DataChange object to the list of changes
			dataChange.next = currentChanges;
			currentChanges = dataChange;
			
			return dataChange;
		}
		*/
		/**
		 * Completes the DataChange, broadcasting all changes to data since this
		 * change started.
		 */
		/*
		public static function completeChange(source:Object, initialProperty:String):void
		{
			if (headChange[initialProperty] != source) {
				return;
			}
			delete headChange[initialProperty];
			
			var dataChange:DataChange = currentChanges;
			var poolChange:DataChange;
			currentChanges = null;
			while (dataChange) {
				
				if (dataChange.oldValue != dataChange.newValue || dataChange.force) {
					// broadcast change to registered callbacks
					for each (var callback:Function in staticCallbacks) {
						callback(dataChange);
					
					}
					if (dataChange is IEventDispatcher) {
						var dispatcher:IEventDispatcher = IEventDispatcher(dataChange)
						var eventType:String = dataChange.property + "Change";
						if (dispatcher.hasEventListener(eventType)) {
							dispatcher.dispatchEvent(new Event(eventType));
						}
					}
				}
				
				// progress to the next DataChange
				poolChange = dataChange;
				dataChange = dataChange.next;
				
				// clear and store previous DataChange in the object pool for reuse
				poolChange.source = poolChange.oldValue = poolChange.newValue = null;
				poolChange.next = objectPool;
				objectPool = poolChange;
			}
		}
		
		public var source:Object;
		public var property:String;
		public var oldValue:*
		public var newValue:*;
		
		private var force:Boolean;
		private var next:DataChange;
		
		public function complete():void
		{
			completeChange(source, property);
		}
		*/
	}
}
