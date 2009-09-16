package mx.styles
{
	import mx.core.mx_internal;

	public class CSSStyleDeclaration
	{
		public var index:int;
		protected var _styles:Object = {};
		protected var _selector:CSSSelector;
		
		public function CSSStyleDeclaration(selector:CSSSelector = null)
		{
			if (selector) {
				StyleManager.setStyleDeclaration(selector.toString(), this);
			}
			_selector = selector;
		}
		
		public function get selector():CSSSelector
		{
			return _selector;
		}
		
		public function get specificity():uint
		{
			return _selector.specificity;
		}
		
		public function get styles():Object
		{
			return _styles;
		}
		
		public function getStyle(styleProp:String):*
		{
			return _styles[styleProp];
		}
		
		mx_internal function setStyle(styleProp:String, value:*):void
		{
			_styles[styleProp] = value;
		}
		
		// always return null so that the new factory will be set
		public function get factory():Function
		{
			return null;
		}
		
		public function set factory(value:Function):void
		{
			var styles:Object = {};
			value.call(styles);
			for (var i:String in styles) {
				mx_internal::setStyle(i, styles[i]);
			}
		}
	}
}