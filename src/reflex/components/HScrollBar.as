package reflex.components
{
	
	import reflex.behaviors.SlideBehavior;
	import reflex.behaviors.StepBehavior;
	import reflex.data.ScrollPosition;
	import reflex.skins.GraphicHSliderSkin;

	public class HScrollBar extends SliderDefinition
	{
		
		public function HScrollBar()
		{
			super();
			position = new ScrollPosition();
			skin = new GraphicHSliderSkin();
			behaviors.addItem(new StepBehavior(this));
			behaviors.addItem(new SlideBehavior(this, SlideBehavior.HORIZONTAL, true));
			//measured.width = 170;
			//measured.height = 20;
		}
		
	}
}