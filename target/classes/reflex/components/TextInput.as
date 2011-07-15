package reflex.components
{
	import reflex.binding.Bind;
	import reflex.binding.DataChange;
	import reflex.skins.TextInputSkin;

	public class TextInput extends Component
	{
		
		private var _text:String;
		
		[Bindable(event="textChange")]
		[Inspectable(name="Text", type=String, defaultValue="Text")]
		public function get text():String { return _text; }
		public function set text(value:String):void {
			DataChange.change(this, "text", _text, _text = value);
		}
		
		public function TextInput(text:String = "")
		{
			super();
			this.text = text;
			skin = new TextInputSkin();
			Bind.addBinding(this, "skin.textField.text", this, "text", true);
			Bind.addBinding(this, "skin.currentState", this, "currentState", false);
		}
		
	}
}