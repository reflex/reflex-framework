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
	public class PropertyChange
	{
		// STATICS //
		
		private static var hooks:Dictionary = new Dictionary(true);
		private static var observers:Dictionary = new Dictionary(true);
		private static var classes:Array = [];
		private static var currentPriority:uint;
		private static var pool:PropertyChange;
		
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
		 * <code>
		 * private function theHook(...):* {...}
		 * private var myHook:Function = theHook; // reference to method
		 * </code>
		 * This is only needed if hookHost is null;
		 * 
		 * @param The hook is a method with one of the following signatures or
		 * something similar (e.g. if you know only strings will be processed,
		 * you can type oldValue, newValue, and the
		 * return type to String rather than *).
		 * 
		 * <code>
		 * function hook(newValue:*):*;
		 * function hook(currentValue:*, newValue:*):*;
		 * function hook(property:String, currentValue:*, newValue:*):*;
		 * function hook(target:Object, property:String, currentValue:*, newValue:*):*;
		 * </code>
		 * 
		 * @param The priority affects the order which observers are notified.
		 * The higher the priority the sooner it will be notified in the list.
		 * This can be negative.
		 */
		public static function addHook(target:Object, property:String, hookHost:IEventDispatcher, hook:Function, priority:int = 0):void
		{
			addMethod(hooks, target, property, hookHost, hook, priority);
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
		 * <code>
		 * private function theObserver(...):* {...}
		 * private var myObserver:Function = theObserver; // reference to method
		 * </code>
		 * This is only needed if observerHost is null;
		 * 
		 * @param The observer is a method with one of the following signatures
		 * or something similar (e.g. if you know only strings will be used,
		 * you can type oldValue and <code>newValue</code> to
		 * String rather than *).
		 * 
		 * <code>
		 * function myObserver(newValue:*):void;
		 * function myObserver(oldValue:*, newValue:*):void;
		 * function myObserver(property:String, oldValue:*, newValue:*):void;
		 * function myObserver(target:Object, property:String, oldValue:*, newValue:*):void;
		 * </code>
		 * 
		 * @param The priority affects the order which observers are notified.
		 * The higher the priority the sooner it will be notified in the list.
		 * This can be negative.
		 */
		public static function addObserver(target:Object, property:String, observerHost:IEventDispatcher, observer:Function, priority:int = 0):void
		{
			addMethod(observers, target, property, observerHost, observer, priority);
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
		 * Start a new property change transaction. A transaction allows you to
		 * dispatch one or more changes at a time, giving the system a chance to
		 * set all the necessary properties before the observers respond. No
		 * observers will be notified until <code>commit()</code> is called.
		 * 
		 * @return A property change object used to aggregate all changes in the
		 * transaction.
		 */
		public static function begin():PropertyChange
		{
			var change:PropertyChange;
			
			if (pool == null) {
				change = new PropertyChange();
			} else {
				change = pool;
				pool = change.next;
				change.next = null;
			}
			
			return change;
		}
		
		
		// INSTANCE //
		
		private var pendingChanges:Change;
		private var next:PropertyChange;
		
		/**
		 * Add a property change to the transaction and allow a new property's
		 * value to be modified by the hook system before being set. This should
		 * be called from within a setter. The private/protected property which
		 * holds the actual value should be set to the result of change.
		 * 
		 * notify() starts a new transaction as it were which is
		 * finished by the resulting notify() call.
		 * notify() MUST be called after each change()
		 * has been called in order to close the loop. If it is not called
		 * notifications will be displaced.
		 * 
		 * Example:
		 * <code>
		 * public function set foo(value:String):void
		 * {
		 *     var change:PropertyChange = PropertyChange.begin();
		 *     _foo = change.add(this, "foo", _foo, value);
		 *     change.commit();
		 * }
		 * </code>
		 * 
		 * @param The target, should be this in a setter.
		 * @param The name of the property being changed.
		 * @param The current value of the property.
		 * @param The new value which the property is being set to.
		 * @return The actual new value (after hooks) which the property should
		 * be set to.
		 */
		public function add(target:Object, property:String, currentValue:*, newValue:*):*
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
			
			var hooks:Array = getMethods(PropertyChange.hooks, target, property);
			return runMethods(hooks, change, true);
		}
		
		/**
		 * Whether or not the property was actually changed. Hooks may prevent
		 * a property from being changed by setting the new value to that of the
		 * old.
		 * 
		 * Note that calling <code>commit()</code> is necessary for the <code>
		 * PropertyChange</code> object to be returned to an object pool for
		 * reuse. If nothing has changed it will not notify any observers, but
		 * still cleans itself up and inserts back into the pool.
		 * 
		 * <code>
		 * var change:PropertyChange = PropertyChange.begin();
		 * _foo = change.add(this, "foo", _foo, value);
		 * if (!change.hasChanged()) {
		 *     // do other necessary processing here.
		 * }
		 * change.commit();
		 * </code>
		 * 
		 * @return Whether the property/properties have changed. If any
		 * properties added have been changed will return true.
		 */
		public function hasChanged():Boolean
		{
			var change:Change = pendingChanges;
			while (change) {
				if (change.oldValue !== change.newValue) {
					return true;
				}
				change = change.next;
			}
			return false;
		}
		
		/**
		 * Returns a change object at the given index. The first change added is
		 * at index 0, the second at index 1, and so on. If a change doesn't
		 * exist at the given index <code>null</code> is returned.
		 * 
		 * The change object returned has the following properties:
		 * <code>
		 * target:Object;
		 * property:String;
		 * oldValue:*;
		 * newValue:*;
		 * </code>
		 */
		public function getChange(index:uint):Change
		{
			var count:int = 0;
			var change:Change = pendingChanges;
			while (change) {
				++count;
				change = change.next;
			}
			
			var reverseIndex:int = count - index;
			if (reverseIndex <= 0) return null;
			
			change = pendingChanges;
			while (--reverseIndex) {
				change = change.next;
			}
			return change;
		}
		
		/**
		 * Notify observers that all properties which have been added to this
		 * transaction previously has finished changes. If the value for a
		 * particular change has not changed no observers will be notified, but
		 * <code>commit()</code> should still be called to clean up the
		 * transaction and return the change objects to their object pools for
		 * reuse.
		 * 
		 * Example:
		 * <code>
		 * public function set foo(value:String):void
		 * {
		 *     var change:PropertyChange = PropertyChange.begin();
		 *     _foo = change.add(this, "foo", _foo, value);
		 *     change.commit();
		 * }
		 * </code>
		 * 
		 * If several changes are added, <code>commit()</code> will notify the
		 * observers in reverse order in which they are added. In the following
		 * example observers listening to <code>percentWidth</code> will be
		 * notified before observers listening to <code>widht</code>.
		 * 
		 * Example:
		 * <code>
		 * public function set width(value:String):void
		 * {
		 *     var change:PropertyChange = PropertyChange.begin();
		 *     _width = change.add(this, "width", _width, value);
		 *     if (!isNaN(_width)) { // if width is set to a real value, nullify percentWidth
		 *         _percentWidth = change.add(this, "percentWidth", _percentWidth, NaN);
		 *     }
		 *     change.commit();
		 * }
		 * </code>
		 */
		public function commit():void
		{
			while (pendingChanges) {
				var change:Change = pendingChanges;
				pendingChanges = change.next;
				
				if (change.oldValue !== change.newValue) {
					var observers:Array = getMethods(PropertyChange.observers, change.target, change.property);
					runMethods(observers, change);
				}
				
				// put change back into its pool
				Change.put(change);
			}
			
			// put this (PropertyChange) back its the pool
			next = pool;
			pool = this;
		}
		
		
		// PRIVATE STATICS //
		
		/**
		 * Adds listening methods (hooks or observers) to their repsective
		 * dictionary. If the target is a Class or Interface it will add it to
		 * the classes array for speedier lookup since classes are kept in
		 * memory anyway.
		 */
		private static function addMethod(type:Dictionary, target:Object, property:String, methodHost:IEventDispatcher, method:Function, priority:int):void
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
				var methods:Dictionary = properties[property];
				if (!methods) {
					properties[property] = methods = new Dictionary(true);
				}
				
				if ( !(method in methods) ) {
					methods[method] = (priority * 1000000) + currentPriority++; // allows order within a priority (assuming added observer count will be less than 1 million, is this bad?)
				}
			}
			
			if (methodHost) {
				methodHost.addEventListener("_", method);
			}
		}
		
		/**
		 * Removes a method from the dictionary.
		 */
		private static function removeMethod(type:Dictionary, target:Object, property:String, method:Function):void
		{
			var properties:Object = type[target];
			if (!properties) return;
			
			var props:Array = property.split(/\s*,\s*/);
			
			for each (property in props) {
				var methods:Dictionary = properties[property];
				if (!methods) return;
				
				delete methods[method];
			}
		}
		
		/**
		 * Runs the methods for a given property change.
		 */
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
		
		/**
		 * Aggregates the methods for a given change and sorts them by priority.
		 * These methods may be coming from class 
		 */
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
				if (target is superClass) {
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
		 * is sorted by priority. This ensures the order items are added is the
		 * order they are dispatched with similar priorities.
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


/**
 * A small pooled link-list object that keeps state for a change that is being
 * processed.
 */
internal final class Change
{
	public var target:Object;
	public var property:String;
	public var oldValue:*;
	public var newValue:*;
	internal var next:Change;
	
	private static var pool:Change;
	
	public static function get(target:Object, property:String, oldValue:*, newValue:*):Change
	{
		var change:Change;
		
		if (pool == null) {
			change = new Change();
		} else {
			change = pool;
			pool = change.next;
			change.next = null;
		}
		
		change.target = target;
		change.property = property;
		change.oldValue = oldValue;
		change.newValue = newValue;
		
		return change;
	}
	
	public static function put(change:Change):void
	{
		change.target = null;
		change.property = null;
		change.oldValue = null;
		change.newValue = null;
		change.next = pool;
		pool = change;
	}
}

/**
 * A small pooled link-list object that allows methods to be sorted by the order
 * in which they were added to the observing system.
 */
internal final class MethodPriority
{
	public var target:Function;
	public var priority:uint;
	public var next:MethodPriority;
	
	private static var pool:MethodPriority;
	
	public static function get(target:Function, priority:uint):MethodPriority
	{
		var mp:MethodPriority;
		
		if (pool == null) {
			mp = new MethodPriority();
		} else {
			mp = pool;
			pool = mp.next;
		}
		
		mp.target = target;
		mp.priority = priority;
		
		return mp;
	}
	
	public static function put(mp:MethodPriority):void
	{
		mp.target = null;
		mp.next = pool;
		pool = mp;
	}
	
	public static function sort(mpA:MethodPriority, mpB:MethodPriority):int
	{
		return mpA.priority - mpB.priority;
	}
	
	public static function map(item:MethodPriority, index:int, array:Array):Function
	{
		return item.target;
	}
}