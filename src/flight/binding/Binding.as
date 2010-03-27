package flight.binding
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import flight.observers.PropertyChange;
	import flight.utils.Type;
	import flight.utils.getClassName;
	import flight.utils.getType;
	
	import mx.events.PropertyChangeEvent;
	
	[ExcludeClass]
	
	/**
	 * Binding will bind two properties together. They can be shallow or deep
	 * and one way or two way.
	 */
	public class Binding
	{
		protected static const SOURCE:String = "source";
		protected static const TARGET:String = "target";
		
		protected var sourceIndices:Dictionary = new Dictionary(true);
		protected var targetIndices:Dictionary = new Dictionary(true);
		
		protected var _sourcePath:Array;
		protected var _targetPath:Array;
		
		protected var _twoWay:Boolean;
		protected var _value:*;
		
		protected var sourceResolved:Boolean;
		protected var targetResolved:Boolean;
		protected var updating:Boolean;
		
		protected var changeFunction:Function = propertyChange;
		
		/**
		 * 
		 */
		public function Binding(target:Object = null, targetPath:Object = null, source:Object = null, sourcePath:Object = null, twoWay:Boolean = false)
		{
			if (target && targetPath && source && sourcePath) {
				reset(target, targetPath, source, sourcePath, twoWay);
			}
		}
		
		/**
		 * Indicates whether this binding has dropped either the source or the
		 * target. If either were dropped out of memory the binding is no longer
		 * valid and shoudl be released appropriatly.
		 */
		public function get isInvalid():Boolean
		{
			var i:Object;
			for (i in sourceIndices) {
				for (i in targetIndices) return false;
			}
			return true;
		}
		
		public function get target():Object
		{
			for (var i:Object in targetIndices) {
				if (targetIndices[i] == 0) return i;
			}
			return null;
		}
		
		public function get source():Object
		{
			for (var i:Object in sourceIndices) {
				if (sourceIndices[i] == 0) return i;
			}
			return null;
		}
		
		public function get targetPath():String
		{
			return _targetPath.join(".");
		}
		
		public function get sourcePath():String
		{
			return _sourcePath.join(".");
		}
		
		public function get twoWay():Boolean
		{
			return _twoWay;
		}
		
		public function get value():*
		{
			return _value;
		}
		
		/**
		 * 
		 */
		public function release():void
		{
			unbindPath(SOURCE, 0);
			unbindPath(TARGET, 0);
			_sourcePath = null;
			_targetPath = null;
			_twoWay = false;
			sourceResolved = false;
			targetResolved = false;
			_value = undefined;
		}
		
		public function reset(target:Object, targetPath:Object, source:Object, sourcePath:Object, twoWay:Boolean):void
		{
			release();
			_twoWay = twoWay;
			
			_sourcePath = makePath(sourcePath);
			_targetPath = makePath(targetPath);
			
			bindPath(TARGET, target, 0);
			update(SOURCE, source, 0);
		}
		
		protected function update(type:String, item:Object, pathIndex:int = 0):void
		{
			var indices:Dictionary = this[type + "Indices"];
			var path:Array = this["_" + type + "Path"];
			
			var oldValue:* = _value;
			_value = bindPath(type, item, pathIndex);		// udpate full path
			
			if (oldValue === _value) return;
			
			updating = true;
			var otherType:String = (type == SOURCE ? TARGET : SOURCE);
			var resolved:Boolean = this[otherType + "Resolved"];
			if (resolved) {
				var otherPath:Array = this["_" + otherType + "Path"];
				var otherItem:Object = getItem(otherType, otherPath.length - 1); // item + path.length
				if (otherItem) {
					var prop:Object = otherPath[otherPath.length - 1];
					setProp(otherItem, prop, oldValue, _value);
				}
			}
			updating = false;
		}
		
		/**
		 * Bind a path up starting from the given index.
		 */
		protected function bindPath(type:String, item:Object, pathIndex:int):*
		{
			var indices:Dictionary = this[type + "Indices"];
			var path:Array = this["_" + type + "Path"];
			var onPropertyChange:Function = this[type + "ChangeHandler"];
			
			unbindPath(type, pathIndex);
			
			var resolved:Boolean;
			var prop:Object;
			var len:int = path.length;
			for (pathIndex; pathIndex < len; pathIndex++) {
				
				if (item == null) {
					break;
				}
				
				indices[item] = pathIndex;
				
				prop = path[pathIndex];
				var propName:String = getPropName(prop);
				
				if (propName && _twoWay || type == SOURCE || pathIndex < len-1) {
					var changeEvents:Array = getBindingEvents(item, propName);
					if (changeEvents == null || changeEvents[0] == "observable") {
						PropertyChange.addObserver(item, propName, null, propertyChange);
					} else if (item is IEventDispatcher) {
						for each (var changeEvent:String in changeEvents) {
							IEventDispatcher(item).addEventListener(changeEvent, onPropertyChange, false, 100, true);
						}
					} else {
						trace("Warning: Property '" + propName + "' is not bindable in " + getClassName(item) + ".");
					}
				}
				
				try {
					item = getProp(item, prop);
				} catch (e:Error) {
					item = null;
				}
			}
			
			// if we've reached the end of the chain successfully (item + path - 1)
			this[type + "Resolved"] = resolved = Boolean(pathIndex == len || item != null);
			if (!resolved) {
				return null;
			}
			
			return item;
		}
		
		/**
		 * Removes all event listeners from a certain point (index) in the path
		 * on up. A pathIndex of 0 will remove all listeners for the given type.
		 */
		protected function unbindPath(type:String, pathIndex:int):void
		{
			var indices:Dictionary = this[type + "Indices"];
			var path:Array = this["_" + type + "Path"];
			var onPropertyChange:Function = this[type + "ChangeHandler"];
			
			for (var item:* in indices) {
				var index:int = indices[item];
				if (index < pathIndex) {
					continue;
				}
				
				var propName:String = getPropName(path[index]);
				var changeEvents:Array = getBindingEvents(item, propName);
				if (changeEvents == null || changeEvents[0] == "observable") {
					PropertyChange.removeObserver(item, propName, propertyChange);
				} else if (item is IEventDispatcher) {
					for each (var changeEvent:String in changeEvents) {
						IEventDispatcher(item).removeEventListener(changeEvent, onPropertyChange);
					}
				}
				delete indices[item];
			}
		}
		
		
		protected function getItem(type:String, pathIndex:int = 0):Object
		{
			var indices:Dictionary = this[type + "Indices"];
			
			for (var item:* in indices) {
				if (indices[item] != pathIndex) {
					continue;
				}
				return item;
			}
			
			return null;
		}
		
		protected function makePath(value:Object):Array
		{
			if (value is String) {
				return String(value).split(".");
			} else if (value is Array) {
				return value as Array;
			} else if (value != null) {
				return [value];
			}
			return [];
		}
		
		protected function getPropName(prop:Object):String
		{
			if (prop is String) return prop as String;
			if ("name" in prop) return prop.name;
			return null;
		}
		
		protected function getProp(item:Object, prop:Object):*
		{
			var func:Function;
			
			if ((func = prop as Function)
				|| ("getter" in prop && (func = prop.getter as Function))
				|| (prop in item && (func = item[prop] as Function)))
			{
				var params:Array = [item];
				params.length = Math.min(func.length, 1);
				return func.apply(null, params);
			}
			
			try {
				return item[prop];
			} catch (e:Error){}
			
			return null;
		}
		
		protected function setProp(item:Object, prop:Object, oldValue:*, value:*):void
		{
			var func:Function;
			
			if ((func = prop as Function)
				|| ("getter" in prop && (func = prop.getter as Function))
				|| (prop in item && (func = item[prop] as Function)))
			{
				var params:Array = [_value, oldValue, item, this];
				params.length = Math.min(func.length, 4);
				func.apply(null, params.reverse());
				return;
			}
			
			try {
				item[prop] = value;
			} catch (e:Error){}
		}
		
		public function propertyChange(target:Object, name:String, oldValue:*, newValue:*):void
		{
			if (updating) return;
			var pathIndex:int, prop:String;
			
			if (target in sourceIndices) {
				pathIndex = sourceIndices[target];
				prop = _sourcePath[pathIndex];
				if (prop == name) {
					update(SOURCE, target[prop], pathIndex + 1);
					return; // done
				}
			}
			
			if (target in targetIndices) {
				pathIndex = targetIndices[target];
				prop = _targetPath[pathIndex];
				
				if (prop == name) {
					if (_twoWay) {
						update(TARGET, target[prop], pathIndex + 1);
					} else {
						bindPath(TARGET, target[prop], pathIndex + 1);
						if (sourceResolved && targetResolved) {
							target = getItem(TARGET, _targetPath.length - 1);
							prop = _targetPath[_targetPath.length - 1];
							try {
								target[prop] = _value;
							} catch (e:Error) {}
						}
					}
				}
			}
		}
		
		protected function sourceChangeHandler(event:Event):void
		{
			if (updating) return;
			var source:Object = event.target;
			var pathIndex:int = sourceIndices[source];
			var prop:String = _sourcePath[pathIndex];
			if (event is PropertyChangeEvent && PropertyChangeEvent(event).property != prop) {
				return;
			}
			
			update(SOURCE, source[prop], pathIndex + 1);
		}
		
		protected function targetChangeHandler(event:Event):void
		{
			if (updating) return;
			var target:Object = event.target;
			var pathIndex:int = targetIndices[target];
			var prop:String = _targetPath[pathIndex];
			if (event is PropertyChangeEvent && PropertyChangeEvent(event).property != prop) {
				return;
			}
			
			if (_twoWay) {
				update(TARGET, target[prop], pathIndex + 1);
			} else {
				bindPath(TARGET, target[prop], pathIndex + 1);
				if (sourceResolved && targetResolved) {
					target = getItem(TARGET, _targetPath.length - 1);
					prop = _targetPath[_targetPath.length - 1];
					try {
						target[prop] = _value;
					} catch (e:Error) {}
				}
			}
		}
		
		
		protected static var descCache:Dictionary = new Dictionary();
		
		protected static function getBindingEvents(target:Object, property:String):Array
		{
			var bindings:Object = describeBindings(target);
			return bindings[property];
		}
		
		protected static function describeBindings(value:Object):Object
		{
			if ( !(value is Class) ) {
				value = getType(value);
			}
			
			if (descCache[value] == null) {
				var desc:XMLList = Type.describeProperties(value, "Bindable");
				var bindings:Object = descCache[value] = {};
				
				for each (var prop:XML in desc) {
					var property:String = prop.@name;
					var changeEvents:Array = [];
					var bindable:XMLList = prop.metadata.(@name == "Bindable");
					
					for each (var bind:XML in bindable) {
						if (bind.arg.(@value == "observable").length()) {
							changeEvents.length = 0;
							changeEvents.push("observable");
							break;
						} else {
							var changeEvent:String = (bind.arg.(@key == "event").length() != 0) ?
								bind.arg.(@key == "event").@value :
								changeEvent = bind.arg.@value;
							
							changeEvents.push(changeEvent);
						}
					}
					
					bindings[property] = changeEvents;
				}
			}
			
			return descCache[value];
		}
		
	}
}
