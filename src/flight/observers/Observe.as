package flight.observers
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * Provides a system for observering property changes on objects and hooking
	 * into those changes to alter the values or prevent the changes from
	 * occuring.
	 * 
	 * Each change is a transaction that can be nested to ensure changes 
	 * triggered by other changes will send out notifications in the correct
	 * order.
	 * 
	 * Hooks allow property changes to be altered or canceled.
	 * Observers allow responding to changes that have occured.
	 */
	public class Observe
	{
		private static var hooks:Dictionary = new Dictionary(true);
		private static var observers:Dictionary = new Dictionary(true);
		private static var classes:Array = [];
		private static var pendingChanges:Change;
		private static var currentPriority:uint;
		
		/**
		 * Adds a method that hooks into the setter process of an observable
		 * property. Hooks allow a method to alter the value or cancel the
		 * property's change.
		 * 
		 * To cancel the property change, return the oldValue. This means there
		 * is no change and the remaining hooks and observers will not be run.
		 * 
		 * To alter the new property value return the desired value.
		 * 
		 * If no value is returned at all, the process will continue as if that
		 * hook hadn't run. This will also be the case if newValue
		 * is returned unchanged.
		 * 
		 * Hooks are run in the order in which they were added.
		 * 
		 * @param The target object for which the hook will apply. If a class
		 * object is provided then all objects of that class type or a subclass
		 * will utilize the hook.
		 * 
		 * @param The name of the property which the hook should attempt to
		 * alter. "*" may be used to indicate any property. A comma
		 * delimited string of properties may be used to add one hook to
		 * multiple properties in one call.
		 * 
		 * @param The hook host is the object which the hook method belongs to.
		 * It is needed to ensure a weak-referenced system. If the hook does not
		 * have an IEventDispatcher it belongs to, null
		 * may be passed in, but the hook must be referenced directly by a
		 * property due to how weak-referenced dictionaries hold functions.
		 * Example:
		 * &lt;code&gt;
		 * private function theHook(...):* {...}
		 * private var myHook:Function = theHook; // reference to method
		 * &lt;/code&gt;
		 * This is only needed if hookHost is null;
		 * 
		 * @param The hook is a method with one of the following signatures or
		 * something similar (e.g. if you know only strings will be processed,
		 * you can type oldValue, newValue, and the
		 * return type to String rather than *).
		 * 
		 * &lt;code&gt;
		 * function hook(newValue:*):*;
		 * function hook(currentValue:*, newValue:*):*;
		 * function hook(property:String, currentValue:*, newValue:*):*;
		 * function hook(target:Object, property:String, currentValue:*, newValue:*):*;
		 * &lt;/code&gt;
		 */
		public static function addHook(target:Object, property:String, hookHost:IEventDispatcher, hook:Function):void
		{
			addMethod(hooks, target, property, hookHost, hook);
		}
		
		/**
		 * Remove a hook which was previously added via addHook.
		 * 
		 * @param The same target that was provided in addHook. If
		 * a class object was used an instance of that class cannot be provided
		 * to remove it for that instance only.
		 * 
		 * @param The name of the property as added in addHook. The
		 * exception is if a comma-delimited string was used you can remove a
		 * subset of those.
		 * 
		 * @param The hook method that was previously added.
		 */
		public static function removeHook(target:Object, property:String, hook:Function):void
		{
			removeMethod(hooks, target, property, hook);
		}
		
		/**
		 * Adds a method that gets notified when an observable property has been
		 * changed.
		 * 
		 * Observers are run in the order in which they were added.
		 * 
		 * @param The target object for which the observer will apply. If a
		 * class object is provided then all objects of that class type or a
		 * subclass will utilize the observer.
		 * 
		 * @param The name of the property which the observer will be notified
		 * about. "*" may be used to indicate any property. A comma
		 * delimited string of properties may be used to add one observer to
		 * multiple properties in one call.
		 * 
		 * @param The observer host is the object which the observer method
		 * belongs to. It is needed to ensure a weak-referenced system. If the
		 * observer does not have an IEventDispatcher it belongs
		 * to, null may be passed in, but the observer must be
		 * referenced directly by a property due to how weak-referenced
		 * dictionaries hold functions.
		 * Example:
		 * &lt;code&gt;
		 * private function theObserver(...):* {...}
		 * private var myObserver:Function = theObserver; // reference to method
		 * &lt;/code&gt;
		 * This is only needed if observerHost is null;
		 * 
		 * @param The observer is a method with one of the following signatures
		 * or something similar (e.g. if you know only strings will be used,
		 * you can type oldValue and <code>newValue</code> to
		 * String rather than *).
		 * 
		 * &lt;code&gt;
		 * function hook(newValue:*):void;
		 * function hook(oldValue:*, newValue:*):void;
		 * function hook(property:String, oldValue:*, newValue:*):void;
		 * function hook(target:Object, property:String, oldValue:*, newValue:*):void;
		 * &lt;/code&gt;
		 */
		public static function addObserver(target:Object, property:String, observerHost:IEventDispatcher, observer:Function):void
		{
			addMethod(observers, target, property, observerHost, observer);
		}
		
		/**
		 * Remove an observer which was previously added via
		 * addObserver.
		 * 
		 * @param The same target that was provided in addObserver.
		 * If a class object was used an instance of that class cannot be
		 * provided to remove it for that instance only.
		 * 
		 * @param The name of the property as added in addObserver.
		 * The exception is if a comma-delimited string was used you can remove a
		 * subset of those.
		 * 
		 * @param The hook observer that was previously added.
		 */
		public static function removeObserver(target:Object, property:String, observer:Function):void
		{
			removeMethod(observers, target, property, observer);
		}
		
		/**
		 * Although the observe system is weak-referenced, you may manually
		 * release the hooks and observers for a particular object.
		 * 
		 * @param The target intance or class for which all hooks and observers
		 * should be removed. If an instance is provided this does not remove
		 * all class-level hooks/observers, only instace-level ones.
		 */
		public static function release(target:Object):void
		{
			var properties:Object, property:String;
			
			properties = hooks[target];
			for (property in properties) {
				delete properties[property];
			}
			
			// sure, it's duplicate code, but it's tiny! c'mon :)
			properties = observers[target];
			for (property in properties) {
				delete properties[property];
			}
		}
		
		/**
		 * Allow a new property's value to be modified by the hook system before
		 * being set. This should be called from within a setter. The'
		 * private/protected property which holds the actual value should be set
		 * to the result of change.
		 * 
		 * notify() starts a new transaction as it were which is
		 * finished by the resulting notify() call.
		 * notify() MUST be called after each change()
		 * has been called in order to close the loop. If it is not called
		 * notifications will be displaced.
		 * 
		 * Example:
		 * public function set foo(value:String):void
		 * {
		 *     _foo = Observe.change(this, "foo", _foo, value);
		 *     Observe.notify();
		 * }
		 * 
		 * @param The target, should be this in a setter.
		 * @param The name of the property being changed.
		 * @param The current value of the property.
		 * @param The new value which the property is being set to.
		 */
		public static function change(target:Object, property:String, currentValue:*, newValue:*):*
		{
			// store the change for this target
			var change:Change = Change.get(target, property, currentValue, newValue);
			if (pendingChanges) {
				change.next = pendingChanges;
			}
			pendingChanges = change;
			
			// don't bother running the hooks if the value hasn't changed.
			if (currentValue === newValue) {
				return currentValue;
			}
			
			var hooks:Array = getMethods(Observe.hooks, target, property);
			return runMethods(hooks, change, true);
		}
		
		/**
		 * Notify observers that a property which has called
		 * change() previously has finished a change. If the
		 * value has not changed no observers will be notified, but notify()
		 * must still be called to close the previous change()
		 * transaction.
		 * 
		 * Example:
		 * public function set foo(value:String):void
		 * {
		 *     _foo = Observe.change(this, "foo", _foo, value);
		 *     Observe.notify();
		 * }
		 * 
		 * All current transactions are stored temporarily, and will be
		 * dispatched in first-in-last-out order. If change() is
		 * called more than once in a setter (for different properties that are
		 * being affected) be sure to call notify the same number of times.
		 * 
		 * Example:
		 * public function set width(value:String):void
		 * {
		 *     _width = Observe.change(this, "width", _width, value);
		 *     if (!isNaN(_width)) { // if width is set to a real value, nullify percentWidth
		 *         _percentWidth = Observe.change(this, "percentWidth", _percentWidth, NaN);
		 *         Observe.notify();
		 *     }
		 *     Observe.notify();
		 * }
		 */
		public static function notify():void
		{
			var change:Change = pendingChanges;
			pendingChanges = change.next;
			
			if (change.oldValue !== change.newValue) {
				var observers:Array = getMethods(Observe.observers, change.target, change.property);
				runMethods(observers, change);
			}
			
			Change.put(change);
		}
		
		
		private static function addMethod(type:Dictionary, target:Object, property:String, observerHost:IEventDispatcher, observer:Function):void
		{
			var properties:Object = type[target];
			if (!properties) {
				type[target] = properties = {};
			}
			
			if (target is Class && classes.indexOf(target) == -1) {
				classes.push(target);
			}
			
			var props:Array = property.split(/\s*,\s*/);
			
			for each (property in props) {
				var observers:Dictionary = properties[property];
				if (!observers) {
					properties[property] = observers = new Dictionary(true);
				}
				
				if ( !(observer in observers) ) {
					observers[observer] = currentPriority++;
				}
			}
			
			if (observerHost != null) {
				observerHost.addEventListener("_", observer);
			}
		}
		
		private static function removeMethod(type:Dictionary, target:Object, property:String, observer:Function):void
		{
			var properties:Object = type[target];
			if (!properties) return;
			
			var props:Array = property.split(/\s*,\s*/);
			
			for each (property in props) {
				var observers:Dictionary = properties[property];
				if (!observers) return;
				
				delete observers[observer];
			}
		}
		
		private static function runMethods(methods:Array, change:Change, isHook:Boolean = false):*
		{
			var result:*;
			for each (var method:Function in methods) {
				if (method.length == 0) {
					result = method.call();
				} else if (method.length == 1) {
					result = method.call(null, change.newValue);
				} else if (method.length == 2) {
					result = method.call(null, change.oldValue, change.newValue);
				} else if (method.length == 3) {
					result = method.call(null, change.property, change.oldValue, change.newValue);
				} else {
					result = method.call(null, change.target, change.property, change.oldValue, change.newValue);
				}
				if (isHook) {
					if (result === undefined) {
						continue; // do nothing for this hook
					} else if (result === change.oldValue) {
						return change.oldValue; // cancel the change
					} else {
						change.newValue = result; // alter the new value
					}
				}
			}
			return change.newValue;
		}
		
		private static function getMethods(type:Dictionary, target:Object, property:String):Array
		{
			var properties:Object, method:Dictionary;
			var dicts:Array = [];
			
			// add the dictionaries for the instance
			properties = type[target];
			if (properties) {
				method = properties[property];
				if (method) dicts.push(method);
				
				method = properties["*"];
				if (method) dicts.push(method);
			}
			
			for each (var superClass:Class in classes) {
				if (superClass != null && target is superClass) {
					properties = type[superClass];
					if (properties) {
						method = properties[property];
						if (method) dicts.push(method);
						
						method = properties["*"];
						if (method) dicts.push(method);
					}
				}
			}
			
			return mergeDictionaries(dicts);
		}
		
		/**
		 * Merge the weak-referenced dictionaries and put together an array that
		 * is sorted by the first methods added to the last. This ensures the
		 * order items are added is the order they are dispatched.
		 */
		private static function mergeDictionaries(dicts:Array):Array
		{
			var methods:Array = [];
			for each (var dict:Dictionary in dicts) {
				if (dict == null) continue;
				for (var method:* in dict) {
					methods.push(MethodPriority.get(method, dict[method]));
				}
			}
			methods.sort(MethodPriority.sort);
			return methods.map(MethodPriority.map);
		}
	}
}