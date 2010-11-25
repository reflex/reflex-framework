package reflex.behaviors
{
	
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
		public static const DISABLED:String = "disabled";
		
		public static const SELECTED_UP:String = "selectedUp";
		public static const SELECTED_OVER:String = "selectedOver";
		public static const SELECTED_DOWN:String = "selectedDown";
		
		
		private var _currentState:String = UP;
		private var _enabled:Boolean = true;
		private var _selected:Boolean = false;
		private var mouseState:String = UP;
		
		[Bindable(event="currentStateChange")]
		[Binding(target="target.currentState")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void {
			DataChange.change(this, "currentState", _currentState, _currentState = value);
		}
		
		[Bindable(event="enabledChange")]
		[Binding(target="target.enabled")]
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void {
			DataChange.change(this, "enabled", _enabled, _enabled = value);
			currentState = resolveState(mouseState);
		}
		
		[Bindable(event="selectedChange")]
		[Binding(target="target.selected")]
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			DataChange.change(this, "selected", _selected, _selected = value);
			currentState = resolveState(mouseState);
		}
		
		public function ButtonBehavior(target:IEventDispatcher = null) {
			super(target);
		}
		
		// ====== Event Listeners ====== //
		
		[EventListener(type="rollOut", target="target")]
		[EventListener(type="releaseOutside", target="target.stage")]
		public function onStateUp(event:MouseEvent):void
		{
			currentState = resolveState(mouseState = UP);
		}
		
		[EventListener(type="rollOver", target="target")]
		[EventListener(type="mouseUp", target="target")]
		public function onStateOver(event:MouseEvent):void
		{
			currentState = resolveState(mouseState = OVER);
		}
		
		[EventListener(type="mouseDown", target="target")]
		public function onStateDown(event:MouseEvent):void
		{
			currentState = resolveState(mouseState = DOWN);
		}
		
		private function resolveState(mouseState:String):String {
			if(!_enabled) {
				return DISABLED;
			} else if(selected) {
				switch(mouseState) {
					case UP: 
						return SELECTED_UP;
						break;
					case OVER: 
						return SELECTED_OVER;
						break;
					case DOWN: 
						return SELECTED_DOWN;
						break;
					default: 
						return UP;
				}
			} else {
				return mouseState;
			}
		}
		
	}
}