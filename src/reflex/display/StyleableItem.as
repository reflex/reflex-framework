package reflex.display
{
	import reflex.styles.IStyleable;
	import reflex.styles.Style;

	public class StyleableItem extends PropertyDispatcher implements IStyleable
	{
		
		private var _id:String;
		private var _styleName:String;
		private var _style:Style;
		
		private var _styleDeclaration:* = {};
		private var _styleManager:* = {};
		
		protected var helper:IDisplayHelper = new FlashDisplayHelper();
		
		private var _display:Object;// = new Sprite();
		
		
		public function get display():Object { return _display; }
		public function set display(value:Object):void {
			_display = value;
		}
		
		public function StyleableItem():void {
			super();
			_style = new Style(); // need to make object props bindable - something like ObjectProxy but lighter?
		}
		
		// IStyleable implementation
		
		[Bindable(event="idChange", noEvent)]
		public function get id():String { return _id; }
		public function set id(value:String):void {
			notify("id", _id, _id = value);
		}
		
		[Bindable(event="styleNameChange", noEvent)]
		public function get styleName():String { return _styleName;}
		public function set styleName(value:String):void {
			notify("styleName", _styleName, _styleName= value);
		}
		
		[Bindable(event="styleChange", noEvent)]
		public function get style():Style { return _style; }
		public function set style(value:*):void { // this needs expanding in the future
			if (value is String) {
				var token:String = value as String;
				reflex.styles.parseStyles(_style, token);
			} else {
				throw new Error("BitmapDisplay.set style() does not currently accept a parameter of type: " + value);
			}
		}
		
		public function getStyle(property:String):* {
			return style[property];
		}
		
		public function setStyle(property:String, value:*):void {
			notify(property, style[property], style[property] = value);
		}
		
		// the compiler goes looking for styleDeclaration and styleManager properties when setting styles on root elements
		// ... but they don't really have to be anything specific :)
		
		public function get styleDeclaration():* { return _styleDeclaration; }
		public function set styleDeclaration(value:*):void {
			_styleDeclaration = value;
		}
		
		public function get styleManager():* { return _styleManager; }
		
	}
}