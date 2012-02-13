package reflex.behaviors
{
	
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import reflex.binding.DataChange;
	import reflex.skins.ISkin;

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
		
		//public static const SELECTED_UP:String = "upAndSelected";
		//public static const SELECTED_OVER:String = "overAndSelected";
		//public static const SELECTED_DOWN:String = "downAndSelected";
		
		
		private var _currentState:String = UP;
		private var _enabled:Boolean = true;
		private var _selected:Boolean = false;
		private var mouseState:String = UP;
		private var _skin:ISkin;
		private var _mouseEnabled:Boolean = true;
		
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
		
		[Bindable(event="skinChange")]
		[Binding(target="target.skin")]
		public function get skin():ISkin { return _skin; }
		public function set skin(value:ISkin):void {
			DataChange.change(this, "skin", _skin, _skin = value);
			currentState = resolveState(mouseState);
		}
		
		[Bindable(event="mouseEnabledChange")]
		public function get mouseEnabled():Boolean { return _mouseEnabled; }
		public function set mouseEnabled(value:Boolean):void {
			DataChange.change(this, "mouseEnabled", _mouseEnabled, _mouseEnabled = value);
		}
		
		public function ButtonBehavior(target:IEventDispatcher = null) {
			super(target);
		}
		
		// ====== Event Listeners ====== //
		
		[EventListener(event="rollOut", target="target")]
		[EventListener(event="releaseOutside", target="target.stage")]
		public function onStateUp(event:MouseEvent):void
		{
			currentState = resolveState(mouseState = UP);
		}
		
		[EventListener(event="rollOver", target="target")]
		[EventListener(event="mouseUp", target="target")]
		public function onStateOver(event:MouseEvent):void
		{
			if(_mouseEnabled) {
				currentState = resolveState(mouseState = OVER);
			}
		}
		
		[EventListener(event="mouseDown", target="target")]
		public function onStateDown(event:MouseEvent):void
		{
			if(_mouseEnabled) {
				currentState = resolveState(mouseState = DOWN);
			}
		}
		
		private function resolveState(mouseState:String):String {
			if(_skin) {
				if(!_enabled && _skin.hasState(DISABLED)) {
					return DISABLED;
				} 
				if(_selected && _skin.hasState(mouseState + "AndSelected")) {
					return mouseState + "AndSelected";
				}
				if(_skin.hasState(mouseState)) {
					return mouseState;
				}	
			}
			return _selected ? mouseState + "AndSelected" : mouseState;
		}
		
	}
}