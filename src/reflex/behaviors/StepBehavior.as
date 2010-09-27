package reflex.behaviors
{
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	
	import reflex.binding.DataChange;
	import reflex.data.IPosition;
	import reflex.data.IRange;
	import reflex.data.ISteppingPosition;
	import reflex.data.Position;
	import reflex.data.Range;

	//import reflex.events.ButtonEvent;
	
	public class StepBehavior extends Behavior
	{
		
		private var _incrementButton:Object;
		private var _decrementButton:Object;
		private var _position:ISteppingPosition;
		
		[Bindable]
		[Binding(target="target.skin.incrementButton")]
		public function get incrementButton():Object { return _incrementButton; }
		public function set incrementButton(value:Object):void {
			DataChange.change(this, "incrementButton", _incrementButton, _incrementButton = value);
		}
		
		[Bindable]
		[Binding(target="target.skin.decrementButton")]
		public function get decrementButton():Object { return _decrementButton; }
		public function set decrementButton(value:Object):void {
			DataChange.change(this, "decrementButton", _decrementButton, _decrementButton = value);
		}
		
		[Bindable]
		[Binding(target="target.position")]
		public function get position():ISteppingPosition { return _position; }
		public function set position(value:ISteppingPosition):void {
			DataChange.change(this, "position", _position, _position = value);
		}
		
		public function StepBehavior(target:IEventDispatcher = null)
		{
			super(target);
		}
		
		[EventListener(type="click", target="incrementButton")]
		public function onFwdPress(event:Event):void
		{
			_position.value += _position.stepSize;
		}
		
		[EventListener(type="click", target="decrementButton")]
		public function onBwdPress(event:Event):void
		{
			_position.value -= _position.stepSize;
		}
		
	}
}