package reflex.components
{
	
	import flash.events.Event;
	
	import reflex.behaviors.SlideBehavior;
	import reflex.behaviors.StepBehavior;
	import reflex.data.ScrollPosition;
	import reflex.skins.VSliderSkin;

	public class VScrollBar extends SliderComponent
	{
		
		public function VScrollBar()
		{
			super();
		}
		
		override protected function initialize():void {
			super.initialize();
			position = new ScrollPosition();
			skin = new VSliderSkin();
			behaviors.addItem(new StepBehavior(this));
			behaviors.addItem(new SlideBehavior(this, SlideBehavior.VERTICAL, true));
			//measured.width = 20;
			//measured.height = 170;
		}
		
	}
}