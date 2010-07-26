package reflex.behaviors
{
	//import reflex.core.IBehavior;

	public class MockBehavior //implements IBehavior
	{
		
		private var _target:Object;
		public function get target():Object { return _target; }
		public function set target(value:Object):void {
			_target = value;
		}
		
	}
}