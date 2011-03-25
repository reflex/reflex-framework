/*
 * Copyright (c) 2009-2010 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package reflex.binding
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.core.IMXMLObject;
	
	/**
	 * The Bind class stands as the primary API for data binding, whether through Bind instances
	 * that represent a target property bound to some data source, or through it's static methods
	 * that allow global binding access. Bind's can be instantiated via ActionScript or MXML and
	 * simplify management of a single binding, allowing target and source to be changed anytime.
	 */
	public class Bind implements IMXMLObject
	{
		public var twoWay:Boolean;
		public var target:String;
		public var source:String;
		
		public function initialized(document:Object, id:String):void
		{
			if (target && source) {
				Bind.addBinding(document, target, document, source, twoWay);
			}
		}
		
		
		protected static var items:Dictionary = new Dictionary(true);
		protected static var listeners:Dictionary = new Dictionary(true);
		protected static var eventListeners:Dictionary = new Dictionary(true);
		protected static var pool:Array = [];
		protected static var holdInMemory:Function = updateListener;
		
		/**
		 * Global utility method binding a target end point to a data source. Once a target is bound
		 * to the source, their values will synchronize immediately and on each subsequent change on
		 * the source. When enabling a two-way bind the source will also update to match the target.
		 * 
		 * @param	target			A reference to the initial object in the target end point, the
		 * 							recipient of binding updates.
		 * @param	targetPath		A property or dot-separated property chain to be resolved in the
		 * 							target end point.
		 * @param	source			A reference to the initial object in the source end point, the
		 * 							initiator of binding updates.
		 * @param	sourcePath		A property or dot-separated property chain to be resolved in the
		 * 							source end point.
		 * @param	twoWay			When enabled, two-way binding updates both target <em>and</em>
		 * 							source upon changes to either.
		 * 
		 * @return					Considered successful if the binding has not already been established.
		 */
		public static function addBinding(target:Object, targetPath:String, source:Object, sourcePath:String, twoWay:Boolean = false):Binding
		{
			return createBinding(target, targetPath, source, sourcePath, twoWay);
		}
		
		/**
		 * Global utility method destroying bindings made via <code>addBinding</code>. Once the binding
		 * is no longer in effect the properties will not be synchronized. However, source and target
		 * values will not be changed by removing the binding, so they will still match initially.
		 * 
		 * @param	target			A reference to the initial object in the target end point, the
		 * 							recipient of binding updates.
		 * @param	targetPath		A property or dot-separated property chain to be resolved in the
		 * 							target end point.
		 * @param	source			A reference to the initial object in the source end point, the
		 * 							initiator of binding updates.
		 * @param	sourcePath		A property or dot-separated property chain to be resolved in the
		 * 							source end point.
		 * 
		 * @return					Considered successful if the specified binding was available.
		 */
		public static function removeBinding(target:Object, targetPath:Object, source:Object, sourcePath:Object, twoWay:Boolean = false):Boolean
		{
			var binding:Binding = getBinding(target, targetPath, source, sourcePath, twoWay);
			if (binding) {
				releaseBinding(binding);
				return true;
			}
			return false;
		}
		
		/**
		 * Removes all bindings, listeners, and bind event listeners that
		 * reference target object.
		 */
		public static function removeAllBindings(target:Object):void
		{
			// bindings and listeners
			var bindings:Array = items[target];
			if (!bindings) {
				return;
			}
			for each (var binding:Binding in bindings) {
				releaseBinding(binding);
			}
			delete items[target];
			
			// event listeners
			delete eventListeners[target];
		}
		
		/**
		 * Global utility method binding an event listener to a data source. Once a listener is bound
		 * to the source, it will receive notification when source values change.
		 * 
		 * @param	listener			An event listener object to be registered with the source binding.
		 * @param	source				A reference to the initial object in the source end point, the
		 * 								initiator of binding updates.
		 * @param	sourcePath			A property or dot-separated property chain to be resolved in the
		 * 								source end point.
		 * @param	useWeakReference	Determines whether the reference to the listener is strong or weak.
		 * 								A weak reference (the default) allows your listener to be garbage-
		 * 								collected. A strong reference does not.
		 */
		public static function addListener(target:IEventDispatcher, listener:Function, source:Object, sourcePath:String):Binding
		{
			if (target) {
				target.addEventListener("_", listener);
			}
			return createBinding(target, listener, source, sourcePath);
		}
		
		/**
		 * Global utility method removing an event listener from a source binding. Once the binding
		 * is no longer in effect the listener will not receive notification when source values change.
		 * 
		 * @param	listener			An event listener object to be removed from the source binding.
		 * @param	source				A reference to the initial object in the source end point, the
		 * 								initiator of binding updates.
		 * @param	sourcePath			A property or dot-separated property chain to be resolved in the
		 * 								source end point.
		 */
		public static function removeListener(target:IEventDispatcher, listener:Function, source:Object, sourcePath:String):Boolean
		{
			return removeBinding(target, listener, source, sourcePath);
		}
		
		// NOTE: weakReference specifies how the listener is added to the endpoint dispatcher, but the listener is held in memory by the binding
		// TODO: refactor to allow the listener to be weakReference
		public static function bindEventListener(type:String, listener:Function, source:Object, sourcePath:String, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):Binding
		{
			var binding:Binding = createBinding(source, updateListener, source, sourcePath);
			
			// store the listener and other properties in a dictionary
			var sourceListeners:Dictionary = eventListeners[source];
			if (!sourceListeners) {
				eventListeners[source] = sourceListeners = new Dictionary(true);
			}
			
			sourceListeners[binding] = [type, listener, useCapture, priority, useWeakReference];
			
			// force update now since the first time couldn't register
			if (binding.value) {
				updateListener(binding, null, null, binding.value);
			}
			return binding;
		}
		
		public static function unbindEventListener(type:String, listener:Function, source:Object, sourcePath:String, useCapture:Boolean = false):Boolean
		{
			var binding:Binding = getBinding(source, updateListener, source, sourcePath);
			
			if (!binding) {
				return false;
			}
			
			var sourceListeners:Dictionary = eventListeners[source];
			if (!sourceListeners) {
				return false;
			}
			
			var args:Array = sourceListeners[binding];
			if (!args) {
				return false;
			}
			
			updateListener(binding, null, binding.value, null);
			delete sourceListeners[binding];
			releaseBinding(binding);
			return true;
		}
		
		protected static function createBinding(target:Object, targetPath:Object, source:Object, sourcePath:Object, twoWay:Boolean = false):Binding
		{
			var binding:Binding = newBinding(target, targetPath, source, sourcePath, twoWay);
			
			// store the binding in relation to the source and target so that
			// they can be manually released.
			var bindings:Array = items[target];
			if (!bindings) {
				items[target] = bindings = [];
			}
			bindings.push(binding);
			
			// if target and source are the same no need to store it twice
			if (target != source) {
				bindings = items[source];
				if (!bindings) {
					items[source] = bindings = [];
				}
			}
			return binding;
		}
		
		protected static function getBinding(target:Object, targetPath:Object, source:Object, sourcePath:Object, twoWay:Boolean = false):Binding
		{
			var bindings:Array = items[target] || items[source];
			if (bindings) {
				for each (var binding:Binding in bindings) {
					if (binding.target == target && binding.source == source
						&& pathEquals(binding.targetPath, targetPath) && pathEquals(binding.sourcePath, sourcePath)
						&& binding.twoWay == twoWay) {
						return binding;
					}
				}
			}
			return null;
		}
		
		protected static function updateListener(binding:Binding, item:Object, oldValue:*, newValue:*):void
		{
			if (!(binding.source in eventListeners && binding in eventListeners[binding.source])) {
				return; // the first update happens before storing in listeners dict
			}
			
			var args:Array = eventListeners[binding.source][binding];
			var dispatcher:IEventDispatcher;
			
			dispatcher = oldValue as IEventDispatcher;
			if (dispatcher != null) {
				dispatcher.removeEventListener(args[0], args[1], args[2]);
			}
			
			dispatcher = newValue as IEventDispatcher;
			if (dispatcher != null) {
				dispatcher.addEventListener(args[0], args[1], args[2], args[3], args[4]);
			}
		}
		
		
		protected static function releaseBinding(binding:Binding):void
		{
			var index:int;
			var bindings:Array;
			var source:Object, target:Object;
			source = binding.source;
			target = binding.target;
			
			// remove from source
			if (source) {
				bindings = items[source];
				if (bindings) {
					index = bindings.indexOf(binding);
					if (index != -1) {
						bindings.splice(index, 1);
					}
				}
			}
			
			// remove from target
			if (target && target != source) {
				bindings = items[target];
				if (bindings) {
					index = bindings.indexOf(binding);
					if (index != -1) {
						bindings.splice(index, 1);
					}
				}
			}
			
			binding.release();
			pool.push(binding);
		}
		
		protected static function newBinding(target:Object, targetPath:Object, source:Object, sourcePath:Object, twoWay:Boolean = false):Binding
		{
			if (pool.length) {
				var binding:Binding = pool.pop();
				binding.reset(target, targetPath, source, sourcePath, twoWay);
				return binding;
			} else {
				return new Binding(target, targetPath, source, sourcePath, twoWay);
			}
		}
		
		protected static function pathEquals(path1:Object, path2:Object):Boolean
		{
			// if they are not the same type
			if (path1.constructor != path2.constructor) return false;
			
			if (path1 is Array) {
				var arr1:Array = path1 as Array, arr2:Array = path2 as Array;
				if (arr1.length != arr2.length) return false;
				var len:int = arr1.length;
				for (var i:int = 0; i < len; i++) {
					if (!pathEquals(arr1[i], arr2[i])) return false;
				}
				return true;
			} else if (path1 is String) {
				return path1 == path2;
			} else if (path1 is Function) {
				return path1 == path2;
			} else {
				for (var j:String in path1) {
					if (path1[j] != path2[j]) return false;
				}
				return true;
			}
		}
	}
}
