package reflex.behaviors
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import reflex.binding.DataChange;
	//import reflex.events.ButtonEvent;
	
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
		//public static const DISABLED:String = "disabled";
		
		
		private var _currentState:String = UP;
		
		[Bindable(event="currentStateChange")]
		[Binding(target="target.currentState")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void {
			DataChange.change(this, "currentState", _currentState, _currentState = value);
		}
		
		public function ButtonBehavior(target:IEventDispatcher = null) {
			super(target);
		}
		
		// ====== Event Listeners ====== //
		
		[EventListener(type="rollOut", target="target")]
		[EventListener(type="releaseOutside", target="target.stage")]
		public function onStateUp(event:MouseEvent):void
		{
			currentState = UP;
		}
		
		[EventListener(type="rollOver", target="target")]
		[EventListener(type="mouseUp", target="target")]
		public function onStateOver(event:MouseEvent):void
		{
			currentState = OVER;
		}
		
		[EventListener(type="mouseDown", target="target")]
		public function onStateDown(event:MouseEvent):void
		{
			currentState = DOWN;
		}
		
	}
}