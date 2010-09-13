/*
 * Copyright (c) 2009-2010 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package reflex.data
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import reflex.metadata.Type;
	import reflex.metadata.getClassName;
	import reflex.metadata.getType;
	
	public class DataBind
	{
		protected var setterObjects:Array = [];
		
		public function bind(target:Object, targetPath:String, source:Object, sourcePath:String, twoWay:Boolean = false, update:Boolean = true):void
		{
			DataBind.bind(target, targetPath, source, sourcePath, twoWay, update);
		}
		
		public function bindSetter(setter:Function, source:Object, sourcePath:String, params:Array = null, update:Boolean = true):void
		{
			setterObjects.push( DataBind.bindSetter(setter, source, sourcePath, params, update) );
		}
		
		public function bindEventListener(type:String, listener:Function, source:Object, sourcePath:String, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			bindSetter(setEventListener, source, sourcePath, [type, listener, useCapture, priority, useWeakReference]);
		}
		
		private function setEventListener(oldValue:*, newValue:*, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if (IEventDispatcher(oldValue) != null) {
				IEventDispatcher(oldValue).removeEventListener(type, listener, useCapture);
			}
			if (IEventDispatcher(newValue) != null) {
				IEventDispatcher(newValue).addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
		
		
		
		public static function bind(target:Object, targetPath:String, source:Object, sourcePath:String, twoWay:Boolean = false, update:Boolean = true):void
		{
			var sourceBindPath:Array = getBindPath(source, sourcePath);
			
			if (twoWay || targetPath.split(".").length > 1) {
				var targetBindPath:Array = getBindPath(target, targetPath);
				
				// bind targetPath to sourcePath
				sourceBindPath.$setters[targetBindPath] = true;
				
				if (twoWay) {
					// bind sourcePath to targetPath
					targetBindPath.$setters[sourceBindPath] = true;
				}
				if (update) {
					setBindPathValue(sourceBindPath.value, targetBindPath);
				}
			} else {
				// bind targetPath to sourcePath
				if (sourceBindPath.$setters[target]) {
					sourceBindPath.$setters[target].push(targetPath);
				} else {
					sourceBindPath.$setters[target] = [targetPath];
				}
				if (update) {
					target[targetPath] = sourceBindPath.value;
				}
			}
		}
		
		public static function bindSetter(setter:Function, source:Object, sourcePath:String, params:Array = null, update:Boolean = true):Object
		{
			params = params || [];
			params.setter = setter;
			var sourceBindPath:Array = getBindPath(source, sourcePath);
			sourceBindPath.$setters[params] = true;
			if (update) {
				var dataChange:Array = [source, sourceBindPath[sourceBindPath.length-1], null, sourceBindPath.value];
				var i:int = dataChange.length - (setter.length - params.length);
				setter.apply(null, dataChange.slice(i).concat(params));
			}
			return params;
		}
		
		public static function releaseBind(target:Object, targetPath:String, source:Object, sourcePath:String):void
		{
			var sourceBindPath:Array = findBindPath(source, sourcePath);
			if (!sourceBindPath) {
				return;
			}
			
			var setters:Dictionary = sourceBindPath.$setters;
			if (targetPath.split(".").length == 1) {
				// bind targetPath to sourcePath
				var index:int;
				if (setters[target] && (index = setters[target].indexOf(targetPath)) != -1) {
					setters[target].slice(index, 1);
				}
			}
			
			var object:Object;
			var targetBindPath:Array = findBindPath(source, sourcePath);
			if (targetBindPath) {
				delete sourceBindPath.$setters[targetBindPath];
				delete targetBindPath.$setters[sourceBindPath];
				
				releaseTarget : {
					for (object in targetBindPath.$setters) {
						break releaseTarget;
					}
					releaseBindPath(targetBindPath);
				}
			}
			
			releaseSource : {
				for (object in sourceBindPath.$setters) {
					break releaseSource;
				}
				releaseBindPath(targetBindPath);
			}
		}
		
		public static function releaseSetter(setter:Function, source:Object, sourcePath:String):void
		{
			var sourceBindPath:Array = getBindPath(source, sourcePath);
			var setters:Dictionary = sourceBindPath.$setters;
			var len:int = 0;
			for (var setterKey:Object in setters) {
				if ("$setter" in setterKey) {
					delete setters[setterKey];
				} else {
					len++;
				}
			}
			if (!len) {
				releaseBindPath(sourceBindPath);
			}
		}
		
		// TODO: add check for isUpdating to avoid recursiveness
		protected static function updateBindPath(bindPath:Array, source:Object):void
		{
			// the source's index will provide a position in the bindPath to retrieve the property
			var sourceIndex:int = bindPath.$sources[source].index;
			var property:String = bindPath[sourceIndex++];
			var value:* = source[property];
			
			// resolve any path left to resolve until the last source/property in the chain
			var len:int = bindPath.length;
			if (sourceIndex < len) {
				
				// aquire the source objects in the chain (pull them from the weak-reference
				// dicitonary keys and store them in the more accessible store array)
				var store:Object = bindPath.$store;
				for (var object:Object in bindPath.$sources) {
					var sourceData:Object = bindPath.$sources[object];
					if (sourceIndex <= sourceData.index) {
						store[sourceData.index] = object;
					}
				}
				
				// iterate as far down the chain as possible (while value != null)
				for (var i:int = sourceIndex; i < len; i++) {
					if (value == null) {
						break;
					}
					
					source = value;
					property = bindPath[i];
					if ( !(property in source) ) {
						trace("Warning: Attempted binding access of undefined property '" + property + "' in " + getClassName(value) + ".");
						break;
					}
					
					// unregister from old source
					unregister(bindPath, store[i]);
					
					// register with new source
					register(bindPath, source, i);
					
					value = source[property];
				}
				for (i; i < len; i++) {
					unregister(bindPath, store[i]);
				}
			}
			
			var oldValue:* = bindPath.value;
			bindPath.value = value;
			
			// update setters!
			var dataChange:Array = [source, property, oldValue, value];
			var setters:Dictionary = bindPath.$setters;
			len = 0;
			for (var setterKey:Object in setters) {
				if ("$setters" in setterKey) {
					// is a bindpath
					setBindPathValue(value, setterKey as Array);
				} else if ("$setter" in setterKey) {
					// is a setter
					var pos:int = dataChange.length - (setterKey.setter.length - setterKey.length);
					setterKey.setter.apply(null, dataChange.slice(pos).concat(setterKey));
				} else {
					// is an array of source/property pair
					for each (property in setters[setterKey]) {
						setterKey[property] = value;		// obj[prop] = value
					}
				}
				len++;
			}
			if (!len) {
				releaseBindPath(bindPath);
			}
		}
		
		protected static function getBindPath(source:Object, sourcePath:String):Array
		{
			var bindPath:Array = findBindPath(source, sourcePath);
			if (bindPath) {
				return bindPath;
			}
			
			// create "BindPath" object as an array with a 'sources' Dictionary
			bindPath = sourcePath.split(".");
			bindPath.$sourcePath = sourcePath;
			// create the 'sources' index of source pointers (keys), also holding linked-lists of BindPaths (values)
			bindPath.$sources = new Dictionary(true);
			bindPath.$setters = new Dictionary(true);
			// utility object for indexing sources when path is ready to update
			bindPath.$store = {};
			
			var len:int = bindPath.length;
			for (var i:int = 0; i < len; i++) {
				var property:String = bindPath[i];
				var sourceData:Object = {index:i, property:property};
				bindPath.$store[-i] = sourceData;
				
				if (source != null) {
					register(bindPath, source, i);
					source = source[property];
				}
			}
			bindPath.value = source;
			
			return bindPath;
		}
		
		protected static function findBindPath(source:Object, sourcePath:String):Array
		{
			var bindPath:Array = bindPaths[source];
			while (bindPath != null) {
				if (bindPath.$sourcePath == sourcePath) {
					return bindPath;
				}
				bindPath = bindPath.$sources[source].next;
			}
			return null;
		}
		
		protected static function register(bindPath:Array, source:Object, index:int):void
		{
			var sourceData:Object = bindPath.$store[-index];
			delete bindPath.$store[-index];
			bindPath.$sources[source] = sourceData;
			sourceData.next = bindPaths[source];
			bindPaths[source] = bindPath;
			
			if (source is IEventDispatcher) {
				var changeEvents:Array// = getBindableEvents(source, sourceData.property);
				if (changeEvents.length) {
					var dispatcher:IEventDispatcher = IEventDispatcher(source);
					for each (var changeEvent:String in changeEvents) {
						dispatcher.addEventListener(changeEvent, onDataChange, false, 0xFF, true);
					}
				}
			}
		}
		
		protected static function unregister(bindPath:Array, source:Object):void
		{
			if (!source) {
				return;
			}
			var sourceData:Object = bindPath.$sources[source];
			delete bindPath.$sources[source];
			var next:Array = sourceData.next;
			sourceData.next = null;
			bindPath.$store[-sourceData.index] = sourceData;
			delete bindPath.$store[sourceData.index];
			
			// remove bindPath from global bindPaths
			if (bindPaths[source] == bindPath) {
				bindPaths[source] = next;
			} else {
				var pathMarker:Array = bindPaths[source];
				while (pathMarker.$sources[source].next != bindPath) {
					pathMarker = pathMarker.$sources[source].next;
				}
				pathMarker.$sources[source].next = next;
			}
			
			if (source is IEventDispatcher) {
				var changeEvents:Array// = getBindableEvents(source, sourceData.property);
				if (changeEvents.length) {
					var dispatcher:IEventDispatcher = IEventDispatcher(source);
					for each (var changeEvent:String in changeEvents) {
						dispatcher.removeEventListener(changeEvent, onDataChange, false);
					}
				}
			}
		}
		
		protected static function releaseBindPath(bindPath:Array):void
		{
			for (var object:Object in bindPath.$sources) {
				unregister(bindPath, object);
			}
		}
		
		protected static function setBindPathValue(value:*, bindPath:Array):void
		{
			var len:int = bindPath.length-1;
			for (var object:Object in bindPath.$sources) {
				var sourceData:Object = bindPath.$sources[object];
				if (sourceData.index == len) {
					object[bindPath[len]] = value;
					break;
				}
			}
		}
		
		protected static var bindPaths:Dictionary = new Dictionary(true);
		DataChange.staticCallbacks.push(onDataChange);
		// dataChange may be a DataChange object, a PropertyChangeEvent or any other Event
		private static function onDataChange(dataChange:Object):void
		{
			var source:Object = dataChange.source || dataChange.target;
			var property:String = dataChange.property || "*";
			var bindPath:Array = bindPaths[source];
			
			while (bindPath != null) {
				var sourceData:Object = bindPath.$sources[source];
				if (sourceData.property == property || property == "*") {
					updateBindPath(bindPath, source);
				}
				bindPath = sourceData.next;
			}
		}
		
		
		protected static var bindableCache:Dictionary = new Dictionary(true);
		
		protected static function getBindableEvents(target:Object, property:String):Array
		{
			if ( !(target is Class) ) {
				target = getType(target);
			}
			
			if (bindableCache[target] == null) {
				var bindableEvents:Array = bindableCache[target] = [];
				var description:XMLList = Type.describeProperties(target, "Bindable");
				
				for each (var prop:XML in description) {
					var propName:String = prop.@name[0];
					var changeEvents:Array = [];
					var bindableList:XMLList = prop.metadata.(@name == "Bindable");
					
					for each (var bindable:XML in bindableList) {
						var changeEvent:String = (bindable.arg.(@key == "event").length() != 0) ?
												  bindable.arg.(@key == "event").@value[0] :
												  bindable.arg.@value[0];
						if (bindable.arg.(@value == "noEvent").length() == 0) {
							changeEvents.push(changeEvent);
						}
					}
					
					bindableEvents[propName] = changeEvents;
				}
			}
			if (bindableCache[target][property] == null) {
				bindableCache[target][property] = [];
			}
			
			return bindableCache[target][property];
		}
		
	}
}
