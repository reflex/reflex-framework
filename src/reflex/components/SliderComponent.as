package reflex.components
{
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import reflex.data.IPosition;
	import reflex.events.DataChangeEvent;
	
	[Event(name="valueChange", type="reflex.events.DataChangeEvent")]
	public class SliderComponent extends Component
	{
		
		private var _position:IPosition;
		
		[Bindable(event="positionChange")]
		public function get position():IPosition { return _position; }
		public function set position(value:IPosition):void {
			if(_position is IEventDispatcher) {
				(_position as IEventDispatcher).removeEventListener("valueChange", redispatch, false);
			}
			notify("position", _position, _position = value);
			if(_position is IEventDispatcher) {
				(_position as IEventDispatcher).addEventListener("valueChange", redispatch, false, 0, true);
			}
		}
		
		private function redispatch(event:Event):void {
			this.dispatchEvent(event);
		}
		
	}
	
}