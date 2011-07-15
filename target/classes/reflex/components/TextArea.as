package reflex.components
{
	import reflex.behaviors.TextAreaBehavior;
	import reflex.binding.Bind;
	import reflex.binding.DataChange;
	import reflex.data.IPosition;
	import reflex.skins.TextAreaSkin;
	
	[Style(name="multiline")]
	public class TextArea extends Component
	{
		
		private var _text:String;
		private var _verticalPosition:IPosition;
		
		[Bindable(event="textChange")]
		[Inspectable(name="Text", type=String, defaultValue="Text")]
		public function get text():String { return _text; }
		public function set text(value:String):void {
			DataChange.change(this, "text", _text, _text = value);
		}
		
		[Bindable(event="verticalPositionChange")]
		public function get verticalPosition():IPosition { return _verticalPosition; }
		public function set verticalPosition(value:IPosition):void {
			DataChange.change(this, "verticalPosition", _verticalPosition, _verticalPosition = value);
		}
		
		public function TextArea(text:String = "")
		{
			super();
			this.text = text;
			skin = new TextAreaSkin(true);
			behaviors = [new TextAreaBehavior(this)];
			Bind.addBinding(this, "skin.textField.text", this, "text", false);
			Bind.addBinding(this, "verticalPosition", this, "skin.verticalScrollBar.position", false);
			Bind.addBinding(this, "skin.currentState", this, "currentState", false);
		}
		
	}
}