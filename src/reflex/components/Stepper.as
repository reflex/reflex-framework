package reflex.components
{
	import flight.position.IPosition;

	public class Stepper extends Component
	{
		[Bindable]
		public var position:IPosition;
		
		public function Stepper()
		{
		}
		
		override protected function init():void
		{
		}
	}
}