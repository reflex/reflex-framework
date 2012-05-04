package reflex.components
{
	
	import flash.events.Event;
	
	import reflex.behaviors.SlideBehavior;
	import reflex.data.Position;
	import reflex.skins.HSliderSkin;

	public class HSlider extends SliderComponent
	{
		
		public function HSlider()
		{
			super();
		}
		
		override protected function initialize(event:Event):void {
			super.initialize(event);
			unscaledHeight = 14;
			position = new Position();
			skin = new HSliderSkin();
			behaviors.addItem(new SlideBehavior(this, SlideBehavior.HORIZONTAL));
			_measuredWidth = 170;
			_measuredHeight = 14;
		}
		
	}
}