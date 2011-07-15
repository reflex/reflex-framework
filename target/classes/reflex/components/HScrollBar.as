package reflex.components
{
	
	import reflex.behaviors.SlideBehavior;
	import reflex.behaviors.StepBehavior;
	import reflex.data.ScrollPosition;
	import reflex.skins.HSliderSkin;

	public class HScrollBar extends SliderComponent
	{
		
		public function HScrollBar()
		{
			super();
			initialize();
		}
		
		private function initialize():void {
			position = new ScrollPosition();
			skin = new HSliderSkin();
			behaviors.addItem(new StepBehavior(this));
			behaviors.addItem(new SlideBehavior(this, SlideBehavior.HORIZONTAL, true));
			//measured.width = 170;
			//measured.height = 20;
		}
		
	}
}