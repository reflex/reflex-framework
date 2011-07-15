package reflex.components
{
	import reflex.behaviors.ButtonBehavior;
	import reflex.behaviors.SelectBehavior;
	import reflex.binding.Bind;
	import reflex.skins.RadioButtonSkin;

	public class RadioButton extends Button
	{
		
		public function RadioButton(label:String = "")
		{
			super();
			this.label = label;
			initialize();
		}
		
		private function initialize():void {
			skin = new RadioButtonSkin();
			behaviors.addItem(new ButtonBehavior(this));
			behaviors.addItem(new SelectBehavior(this));
			Bind.addBinding(this, "skin.labelDisplay.text", this, "label", false);
			Bind.addBinding(this, "skin.currentState", this, "currentState", false);
			measured.width = 210;
			measured.height = 45;
		}
		
	}
}