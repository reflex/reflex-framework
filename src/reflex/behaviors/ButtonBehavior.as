package reflex.behaviors
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	import flight.binding.Bind;
	
	import reflex.skins.ISkinnable;
	import reflex.events.ButtonEvent;
	
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
		public var state:String = UP;
		
		public function ButtonBehavior(target:InteractiveObject = null)
		{
			super(target);
			bindProperty("state", "target.state");
			bindEventListener("stateUp", onStateUp, "target");
			bindEventListener("stateOver", onStateOver, "target");
			bindEventListener("stateDown", onStateDown, "target");
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
		
		protected function onStateUp(event:MouseEvent):void
		{
			state = UP;
			event.updateAfterEvent();
		}
		
		protected function onStateOver(event:MouseEvent):void
		{
			state = OVER;
			event.updateAfterEvent();
		}
		
		protected function onStateDown(event:MouseEvent):void
		{
			state = DOWN;
			event.updateAfterEvent();
		}
		
	}
}