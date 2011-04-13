package reflex.components
{
	
	import reflex.behaviors.SlideBehavior;
	import reflex.behaviors.StepBehavior;
	import reflex.data.ScrollPosition;
	import reflex.skins.GraphicVSliderSkin;

	public class VScrollBar extends SliderDefinition
	{
		
		public function VScrollBar()
		{
			super();
			position = new ScrollPosition();
			skin = new GraphicVSliderSkin();
			behaviors.addItem(new StepBehavior(this));
			behaviors.addItem(new SlideBehavior(this, SlideBehavior.VERTICAL, true));
			//measured.width = 20;
			//measured.height = 170;
		}
		
	}
}