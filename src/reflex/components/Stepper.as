package reflex.components
{
	import flight.events.PropertyEvent;
	import flight.position.IPosition;
	import flight.position.Position;
	
	import reflex.behaviors.StepBehavior;

	//import reflex.skins.StepperSkin;

	public class Stepper extends Component
	{
		
		private var _position:IPosition;
		
		[Bindable(event="positionChange")]
		public function get position():IPosition { return _position; }
		public function set position(value:IPosition):void {
			if(_position == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "position", _position, _position = value);
		}
		
		public function Stepper()
		{
			position = new Position();
			position.value = 0;
			position.min = 0;
			position.max = 100;
			//skin = new StepperSkin();
			behaviors = new StepBehavior();
		}
		
	}
}