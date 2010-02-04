package reflex.behaviors
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	import flight.binding.Bind;
	
	import reflex.skins.ISkinnable;
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
		[Binding(target="target.state")]
		public var state:String;
		
		public function ButtonBehavior(target:InteractiveObject = null)
		{
			super(target);
		}
		
		override public function set target(value:InteractiveObject):void
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