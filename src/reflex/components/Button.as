package reflex.components
{
	import flash.display.MovieClip;
	
	import reflex.behaviors.ButtonBehavior;
	import reflex.behaviors.SelectBehavior;
	import reflex.binding.Bind;
	import reflex.skins.GraphicButtonSkin;

	public class Button extends ButtonDefinition
	{
		
		public function Button(label:String = "")
		{
			super();
			this.label = label;
			skin = new GraphicButtonSkin();
			behaviors.addItem(new ButtonBehavior(this));
			//behaviors.addItem(new SelectBehavior(this));
			Bind.addBinding(this, "skin.labelDisplay.text", this, "label", false);
			Bind.addBinding(this, "skin.currentState", this, "currentState", false);
			measured.width = 210;
			measured.height = 64;
		}
		
	}
}