package reflex.components
{
	
	import flash.display.Sprite;
	
	import reflex.behaviors.SlideBehavior;
	import reflex.data.Position;

	public class Knob extends SliderComponent
	{
		
		public function Knob()
		{
			super();
			position = new Position();
			skin = new Sprite();//new KnobSkin();
			behaviors.addItem(new SlideBehavior(this));
		}
		
	}
}