package reflex.behaviors
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import flight.binding.Bind;
	
	import reflex.events.ButtonEvent;
	import reflex.skins.ISkinnable;
	
	[SkinState("up")]
	[SkinState("over")]
	[SkinState("down")]
	
	[Event(name="buttonDown", type="mx.events.FlexEvent")]
	
	/**
	 * @alpha
	 */
	public class ButtonBehavior extends Behavior implements IBehavior
	{
		public static const UP:String = "up";
		public static const OVER:String = "over";
		public static const DOWN:String = "down";
		
		private var _currentState:String = UP;
		
		[Bindable(event="currentStateChange")]
		[Binding(target="target.currentState")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void {
			_currentState = value;
			dispatchEvent(new Event("currentStateChange"));
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
		
		public function click():void
		{
			target.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		// ====== Event Listeners ====== //
		
		[EventListener(type="stateUp", target="target")]
		public function onStateUp(event:MouseEvent):void
		{
			currentState = UP;
			event.updateAfterEvent();
		}
		
		[EventListener(type="stateOver", target="target")]
		public function onStateOver(event:MouseEvent):void
		{
			currentState = OVER;
			event.updateAfterEvent();
		}
		
		[EventListener(type="stateDown", target="target")]
		public function onStateDown(event:MouseEvent):void
		{
			currentState = DOWN;
			event.updateAfterEvent();
		}
		
	}
}