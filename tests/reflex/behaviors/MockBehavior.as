package reflex.behaviors
{
	import flash.events.IEventDispatcher;

	public class MockBehavior implements IBehavior
	{
		
		private var _target:IEventDispatcher;
		public function get target():IEventDispatcher { return _target; }
		public function set target(value:IEventDispatcher):void {
			_target = value;
		}
		
	}
}