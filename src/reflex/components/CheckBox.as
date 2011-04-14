package reflex.components
{
	import reflex.behaviors.ButtonBehavior;
	import reflex.behaviors.SelectBehavior;
	import reflex.binding.Bind;
	import reflex.skins.CheckBoxSkin;

	public class CheckBox extends Button
	{
		
		public function CheckBox(label:String = "")
		{
			super();
			this.label = label;
			initialize();
		}
		
		private function initialize():void {
			skin = new CheckBoxSkin();
			behaviors.addItem(new ButtonBehavior(this));
			behaviors.addItem(new SelectBehavior(this));
			Bind.addBinding(this, "skin.labelDisplay.text", this, "label", false);
			Bind.addBinding(this, "skin.currentState", this, "currentState", false);
			measured.width = 210;
			measured.height = 45;
		}
		
	}
}