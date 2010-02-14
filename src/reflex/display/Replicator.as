package reflex.display
{
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	import flight.binding.Bind;
	import flight.events.PropertyEvent;
	import flight.position.IPosition;
	import flight.position.Position;

	/**
	 * A replicator can create any inanimate matter, as long as the desired
	 * molecular structure is on file, but it cannot create antimatter,
	 * dilithium, latinum, or a living organism of any kind.
	 */
	public class Replicator extends EventDispatcher
	{
		[Bindable]
		public var position:IPosition = new Position();
		
		private var _target:DisplayObjectContainer;
		
		public function Replicator(target:DisplayObjectContainer = null)
		{
			Bind.addListener(onPositionChange, this, "position.percent");
			this.target = target;
		}
		
		[Bindable(event="targetChange")]
		public function get target():DisplayObjectContainer
		{
			return _target;
		}
		public function set target(value:DisplayObjectContainer):void
		{
			if (_target == value) {
				return;
			}
			
			if (_target != null) {
			}
			
			var oldValue:Object = _target;
			_target = value;
			
			if (_target != null) {
			}
			
			PropertyEvent.dispatchChange(this, "target", oldValue, _target);
		}
		
		private function onPositionChange(event:PropertyEvent):void
		{
			
		}
		
	}
}