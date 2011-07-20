package reflex.components
{
	
	import reflex.behaviors.SlideBehavior;
	import reflex.data.Position;
	import reflex.skins.KnobSkin;

	public class Knob extends SliderComponent
	{
		
		public function Knob()
		{
			super();
			position = new Position();
			skin = new KnobSkin();
			behaviors.addItem(new SlideBehavior(this));
		}
		
	}
}