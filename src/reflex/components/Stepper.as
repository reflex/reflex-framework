package reflex.components
{
	
	import reflex.behaviors.SlideBehavior;
	import reflex.behaviors.StepBehavior;
	import reflex.binding.Bind;
	import reflex.data.Position;
	import reflex.skins.StepperSkin;

	public class Stepper extends SliderDefinition
	{
		
		public function Stepper()
		{
			super();
			position = new Position();
			skin = new StepperSkin();
			behaviors.addItem(new StepBehavior(this));
			Bind.addBinding(this, "skin.textField.text", this, "position.value", true);
		}
		
	}
}