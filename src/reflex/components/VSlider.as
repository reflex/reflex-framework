package reflex.components
{
	
	import flash.events.Event;
	
	import reflex.behaviors.SlideBehavior;
	import reflex.data.IPosition;
	import reflex.data.Position;
	import reflex.skins.VSliderSkin;

	public class VSlider extends SliderComponent
	{
		
		public function VSlider()
		{
			super();
		}
		
		override protected function initialize(event:Event):void {
			super.initialize(event);
			//unscaledWidth = 14;
			position = new Position();
			skin = new VSliderSkin();
			behaviors.addItem(new SlideBehavior(this, SlideBehavior.VERTICAL));
			//_measuredWidth = 20;
			//_measuredHeight = 170;
		}
		
	}
}