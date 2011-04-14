package reflex.components
{
	
	import reflex.behaviors.SlideBehavior;
	import reflex.data.Position;
	import reflex.skins.HSliderSkin;

	public class HSlider extends SliderComponent
	{
		
		public function HSlider()
		{
			super();
			initialize();
		}
		
		private function initialize():void {
			unscaledHeight = 14;
			position = new Position();
			skin = new HSliderSkin();
			behaviors.addItem(new SlideBehavior(this, SlideBehavior.HORIZONTAL));
			measured.width = 170;
			measured.height = 14;
		}
		
	}
}