package reflex.components
{
	
	import reflex.behaviors.ButtonBehavior;
	import reflex.behaviors.SelectBehavior;
	import reflex.binding.Bind;
	import reflex.binding.DataChange;
	import reflex.skins.ButtonSkin;

	public class Button extends Component
	{
		
		private var _label:String;
		private var _selected:Boolean;
		
		[Bindable(event="labelChange")]
		[Inspectable(name="Label", type=String, defaultValue="Label")]
		public function get label():String { return _label; }
		public function set label(value:String):void {
			DataChange.change(this, "label", _label, _label = value);
		}
		
		[Bindable(event="selectedChange")]
		[Inspectable(name="Selected", type=Boolean, defaultValue=false)]
		public function get selected():Boolean {return _selected; }
		public function set selected(value:Boolean):void {
			DataChange.change(this, "selected", _selected, _selected = value);
		}
		
		public function Button(label:String = "")
		{
			super();
			this.label = label;
			initialize();
		}
		
		private function initialize():void {
			skin = new ButtonSkin();
			behaviors.addItem(new ButtonBehavior(this));
			//behaviors.addItem(new SelectBehavior(this));
			Bind.addBinding(this, "skin.labelDisplay.text", this, "label", false);
			Bind.addBinding(this, "skin.currentState", this, "currentState", false);
			measured.width = 210;
			measured.height = 64;
		}
		
	}
}