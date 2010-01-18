package reflex.behavior
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	import flight.binding.Bind;
	
	import reflex.core.IBehavior;
	import reflex.core.ISkinnable;
	import reflex.events.ButtonEvent;
	
	// needed? If they help contribute to documentation or make the state workflow easier
	[SkinState("up")]
	[SkinState("over")]
	[SkinState("down")]
	
	[Event(name="buttonDown", type="mx.events.FlexEvent")]
	
	public class ButtonBehavior extends Behavior implements IBehavior
	{
		public static const UP:String = "up";
		public static const OVER:String = "over";
		public static const DOWN:String = "down";
		
		[Bindable]
		public var state:String;
		
		public function ButtonBehavior()
		{
			// manual linking event listeners to the target (for a Flash Pro workflow)
			Bind.bindEventListener(ButtonEvent.STATE_UP,			onStateUp, this, "target");
			Bind.bindEventListener(ButtonEvent.STATE_OVER,			onStateOver, this, "target");
			Bind.bindEventListener(ButtonEvent.STATE_DOWN,			onStateDown, this, "target");
		}
		
		override public function set target(value:InteractiveObject):void
		{
			if (value is DisplayObjectContainer) {
				DisplayObjectContainer(value).mouseChildren = false;
			}
			ButtonEvent.initialize(value as InteractiveObject);
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
			state = UP;
			event.updateAfterEvent();
		}
		
		[EventListener(type="stateOver", target="target")]
		public function onStateOver(event:MouseEvent):void
		{
			state = OVER;
			event.updateAfterEvent();
		}
		
		[EventListener(type="stateDown", target="target")]
		public function onStateDown(event:MouseEvent):void
		{
			state = DOWN;
			event.updateAfterEvent();
		}
		
	}
}