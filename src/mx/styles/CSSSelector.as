package mx.styles
{
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;


	public class CSSSelector
	{
		protected var _property:String;
		protected var _type:String;
		protected var _conditions:Array;
		protected var _ancestor:CSSSelector;
		protected var _specificity:uint;
		
		public function CSSSelector(type:String, conditions:Array = null, ancestor:CSSSelector = null)
		{
			if (!type || type == "global") type = "*";
			_type = type.split(".").pop();
			_conditions = conditions;
			_ancestor = ancestor;
			_specificity = (type == "*" ? 1 : 0);
			if (type != "*" && type.substr(0, 1).toLowerCase() == type.substr(0, 1)) {
				_property = type; // if this isn't capitalized, it may be a property.
				if (ancestor && ancestor.property) {
					_property + ancestor.property + "." + _property;
				}
			}
			init();
		}
		
		protected function init():void
		{
			if (_conditions) {
				for each (var condition:CSSCondition in _conditions) {
					_specificity += condition.specificity;
				}
				_conditions.sortOn("value");
				_conditions.sortOn("kind");
				_conditions.sortOn("specificity", Array.NUMERIC);
			}
		}
		
		public function get property():String
		{
			return _property;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get conditions():Array
		{
			return _conditions;
		}
		
		public function get ancestor():CSSSelector
		{
			return _ancestor;
		}
		
		public function get specificity():uint
		{
			return _specificity;
		}
		
		public function match(obj:Object, matchAncestors:Boolean = true):Boolean
		{
			var match:Boolean = false;
			var condition:CSSCondition;
			var parent:DisplayObject = obj is DisplayObject ? DisplayObject(obj).parent : null;
			
			// if this is a property
			if (ancestor && matchAncestors && _property) {
				return ancestor.match(obj, matchAncestors);
			} else if (_type != "*" && getTypes(obj).indexOf(_type) == -1) {
				return false;
			}
			
			if (conditions) {
				// must be IStylable to match any of the conditions
				for each (condition in conditions) {
					if (!condition.match(obj)) return false;
				}
			}
			
			if (ancestor && matchAncestors && obj is DisplayObject) {
				var selector:CSSSelector = ancestor;
				while (selector != null) {
					while (parent != null) {
						if (selector.match(parent, false)) {
							selector = selector.ancestor;
							break;
						}
						parent = parent.parent;
					}
					// if we didn't match all the ancestors
					if (parent == null) return false;
				}
			}
			
			return true;
		}
		
		public function getTypes(obj:Object):Array
		{
			var className:String = getQualifiedClassName(obj);
			var types:Array = [className.split("::").pop()];
			
			while (className != "Object") {
				className = getQualifiedSuperclassName(obj);
				types.push(className.split("::").pop());
				obj = getDefinitionByName(className);
			}
			
			return types;
		}
		
		public function toString():String
		{
			var selectors:Array = [];
			var selector:CSSSelector = this;
			while (selector) {
				var str:String = selector.type;
				if (selector.conditions) {
					for each (var condition:CSSCondition in selector.conditions) {
						str += condition;
					}
				}
				selectors.unshift(str);
				selector = selector.ancestor;
			}
			return selectors.join(" ");
		}
	}
}