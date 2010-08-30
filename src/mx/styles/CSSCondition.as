package mx.styles
{
	import flash.display.DisplayObject;
	
	import reflex.components.IStateful;
	import reflex.styles.IStyleable;

	public class CSSCondition
	{
		protected static var onSpace:RegExp = new RegExp("\\s+");
		protected var _kind:String;
		protected var _value:String;
		protected var _specificity:uint;
		
		public function CSSCondition(kind:String, value:String)
		{
			_kind = kind;
			_value = value;
			_specificity = (kind == "id" ? 100 : 10);
		}
		
		public function get kind():String
		{
			return _kind;
		}
		
		public function get value():String
		{
			return _value;
		}
		
		public function get specificity():uint
		{
			return _specificity;
		}
		
		public function match(obj:Object):Boolean
		{
			var stylable:IStyleable = obj as IStyleable;
			var displayObject:DisplayObject = obj as DisplayObject;
			
			if (stylable) {
				if (_kind == "id") return stylable.id == _value;
				if (_kind == "class") return stylable.styleName.split(onSpace).indexOf(_value) != -1;
				if (_kind == "pseudo") {
					try {
						if (displayObject[_value] is Boolean) return displayObject[_value];
					} catch (e:Error) {}
					if(stylable is IStateful) {
						return (stylable as IStateful).currentState == _value;
					}
					return true;
				}
			} else if (_kind == "id" && displayObject) {
				return displayObject.name == _value;
			}
			
			return false;
		}
		
		public function toString():String
		{
			if (_kind == "id") return "#" + _value;
			if (_kind == "class") return "." + _value;
			if (_kind == "pseudo") return ":" + _value;
			return "";
		}
	}
}