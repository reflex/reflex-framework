package reflex.behaviors
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import reflex.binding.Bind;
	import reflex.events.ButtonEvent;
	
	[SkinState("up")]
	[SkinState("over")]
	[SkinState("down")]
	[SkinState("disabled")]
	
	[Event(name="buttonDown", type="mx.events.FlexEvent")]
	
	/**
	 * @alpha
	 */
	public class ButtonBehavior extends Behavior implements IBehavior
	{
		public static const UP:String = "up";
		public static const OVER:String = "over";
		public static const DOWN:String = "down";
		public static const DISABLED:String = "disabled";
		
		// the mouse
		private var mouseState:String = UP;
		private var _currentState:String = UP;
		
		[Bindable(event="currentStateChange")]
		[Binding(target="target.currentState")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void {
			if (value == DISABLED) {
				disabled = true;
			} else if (_disabled) {
				mouseState = value;
			} else {
				_currentState = mouseState = value;
				dispatchEvent(new Event("currentStateChange"));
			}
		}
		
		private var _disabled:Boolean = false;
		
		[Bindable(event="disabledChange")]
		[Binding(target="target.disabled")]
		public function get disabled():Boolean { return _disabled; }
		public function set disabled(value:Boolean):void {
			_disabled = value;
			_currentState = _disabled ? DISABLED : mouseState;
			dispatchEvent(new Event("disabledChange"));
			dispatchEvent(new Event("currentStateChange"));
		}
		
		private var _holdPress:Boolean = false;
		
		[Bindable(event="holdPressChange")]
		[Binding(target="target.holdPress")]
		public function get holdPress():Boolean { return _holdPress; }
		public function set holdPress(value:Boolean):void {
			_holdPress = value;
			if (_holdPress) {
				if (target) {
					target.removeEventListener(ButtonEvent.DRAG_OVER, onStateDown);
					target.removeEventListener(ButtonEvent.DRAG_OUT, onStateOver);
				}
				Bind.unbindEventListener(ButtonEvent.DRAG_OVER, onStateDown, this, "target");
				Bind.unbindEventListener(ButtonEvent.DRAG_OUT, onStateOver, this, "target");
			} else {
				Bind.bindEventListener(ButtonEvent.DRAG_OVER, onStateDown, this, "target");
				Bind.bindEventListener(ButtonEvent.DRAG_OUT, onStateOver, this, "target");
			}
			dispatchEvent(new Event("holdPressChange"));
		}
		
		
		public function ButtonBehavior(target:InteractiveObject = null)
		{
			super(target);
		}
		
		override public function set target(value:IEventDispatcher):void
		{
			if (value != null) {
				if (value is DisplayObjectContainer) {
					DisplayObjectContainer(value).mouseChildren = false;
				}
				ButtonEvent.initialize(value);
			}
			super.target = value;
		}
		
		// ====== Event Listeners ====== //
		
		[EventListener(type="rollOut", target="target")]
		[EventListener(type="releaseOutside", target="target")]
		public function onStateUp(event:MouseEvent):void
		{
			if (event.type == MouseEvent.ROLL_OUT && event.buttonDown) {
				return;
			}
			currentState = UP;
			event.updateAfterEvent();
		}
		
		[EventListener(type="rollOver", target="target")]
		[EventListener(type="dragOut", target="target")]
		[EventListener(type="release", target="target")]
		public function onStateOver(event:MouseEvent):void
		{
			if (event.type == MouseEvent.ROLL_OVER && event.buttonDown) {
				return;
			}
			currentState = OVER;
			event.updateAfterEvent();
		}
		
		[EventListener(type="press", target="target")]
		[EventListener(type="dragOver", target="target")]
		public function onStateDown(event:MouseEvent):void
		{
			currentState = DOWN;
			event.updateAfterEvent();
		}
		
	}
}