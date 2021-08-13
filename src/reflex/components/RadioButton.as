package reflex.components
{
	import flash.events.Event;
	
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
		}
		
		override protected function initialize():void {
			super.initialize();
			skin = new RadioButtonSkin();
			behaviors.addItem(new ButtonBehavior(this));
			behaviors.addItem(new SelectBehavior(this));
			Bind.addBinding(this, "skin.labelDisplay.text", this, "label", false);
			Bind.addBinding(this, "skin.currentState", this, "currentState", false);
			//_measuredWidth = 210;
			//_measuredHeight = 45;
		}
		
	}
}