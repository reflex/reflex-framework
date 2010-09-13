package reflex.components
{
	import reflex.behaviors.StepBehavior;
	import reflex.data.IRange;
	import reflex.data.Range;
	import reflex.events.PropertyEvent;

	//import reflex.skins.StepperSkin;

	public class Stepper extends Component
	{
		
		private var _position:IRange;
		
		[Bindable(event="positionChange")]
		public function get position():IRange { return _position; }
		public function set position(value:IRange):void {
			if (_position == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "position", _position, _position = value);
		}
		
		public function Stepper()
		{
			position = new Range();
			position.position = 0;
			position.min = 0;
			position.max = 100;
			//skin = new StepperSkin();
			behaviors = new StepBehavior();
		}
		
	}
}