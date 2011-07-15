package reflex.components
{
	
	import reflex.binding.DataChange;
	import reflex.data.IPosition;
	import reflex.data.Position;
	import reflex.behaviors.SlideBehavior;
	import reflex.skins.VSliderSkin;

	public class VSlider extends SliderComponent
	{
		
		public function VSlider()
		{
			super();
			initialize();
		}
		
		private function initialize():void {
			unscaledWidth = 14;
			position = new Position();
			skin = new VSliderSkin();
			behaviors.addItem(new SlideBehavior(this, SlideBehavior.VERTICAL));
			measured.width = 20;
			measured.height = 170;
		}
		
	}
}