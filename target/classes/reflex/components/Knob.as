package reflex.components
{
	
	import reflex.behaviors.SlideBehavior;
	import reflex.data.Position;

	public class Knob extends SliderComponent
	{
		
		public function Knob()
		{
			super();
			position = new Position();
			//skin = new ScrollBarGraphic()
			behaviors.addItem(new SlideBehavior(this));
		}
		
	}
}