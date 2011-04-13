package reflex.components
{
	
	import reflex.behaviors.SlideBehavior;
	import reflex.data.Position;
	import reflex.skins.GraphicVSliderSkin;

	public class VSlider extends SliderDefinition
	{
		
		public function VSlider()
		{
			super();
			unscaledWidth = 14;
			position = new Position();
			skin = new GraphicVSliderSkin();
			behaviors.addItem(new SlideBehavior(this, SlideBehavior.VERTICAL));
			measured.width = 20;
			measured.height = 170;
		}
		
	}
}