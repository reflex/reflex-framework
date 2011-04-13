package reflex.components
{
	
	import reflex.behaviors.SlideBehavior;
	import reflex.data.Position;
	import reflex.skins.GraphicHSliderSkin;

	public class HSlider extends SliderDefinition
	{
		
		public function HSlider()
		{
			super();
			unscaledHeight = 14;
			position = new Position();
			skin = new GraphicHSliderSkin();
			behaviors.addItem(new SlideBehavior(this, SlideBehavior.HORIZONTAL));
			measured.width = 170;
			measured.height = 14;
			
		}
		
	}
}