package reflex.behaviors
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	import flight.binding.Bind;
	
	import reflex.controls.IStateful;
	import reflex.core.IBehavior;
	import reflex.events.ButtonEvent;
	
	public class ButtonStateBehavior extends Behavior implements IBehavior
	{
		public static const UP:String = "up";
		public static const OVER:String = "over";
		public static const DOWN:String = "down";
		
		[Alias] [Bindable] public var button:IStateful;
		
		public function ButtonStateBehavior()
		{
			// example of metadata automated linking below...
			//Bind.bindEventListener(ButtonEvent.PRESS,				onPress, this, "target");
			
			// manual linking event listeners to the target (for a Flash Pro workflow)
			Bind.bindEventListener(ButtonEvent.ROLL_OVER,			onRollOver, this, "target");
			Bind.bindEventListener(ButtonEvent.ROLL_OUT,			onRollOut, this, "target");
			Bind.bindEventListener(ButtonEvent.DRAG_OVER,			onDragOver, this, "target");
			Bind.bindEventListener(ButtonEvent.DRAG_OUT,			onDragOut, this, "target");
			Bind.bindEventListener(ButtonEvent.RELEASE,				onRelease, this, "target");
			Bind.bindEventListener(ButtonEvent.RELEASE_OUTSIDE,		onReleaseOutside, this, "target");
		}
		
		override public function set target(value:Object):void
		{
			if (value is DisplayObjectContainer) {
				DisplayObjectContainer(value).mouseChildren = false;
			}
			ButtonEvent.initialize(value as InteractiveObject);
			super.target = value;
		}
		
		// beahvior allows full funcionality via API
		public function click():void
		{
			InteractiveObject(target).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		// ====== Event Listeners ====== //
		
		// example of metadata linking of event listener to target with a path
		// 		[EventListener(type="press", path="myPanel.myButton")]
		// 		public function onButtonPress(event:MouseEvent):void ...
		// note: listener must be public, see onPress below
		
		[EventListener(type="press")]
		public function onPress(event:MouseEvent):void
		{
			button.state = DOWN;
		}
		
		private function onRollOver(event:MouseEvent):void
		{
			button.state = OVER;
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			button.state = UP;
		}
		
		private function onDragOver(event:MouseEvent):void
		{
			button.state = DOWN;
		}
		
		private function onDragOut(event:MouseEvent):void
		{
			button.state = OVER;
		}
		
		private function onRelease(event:MouseEvent):void
		{
			button.state = OVER;
		}
		
		private function onReleaseOutside(event:MouseEvent):void
		{
			button.state = UP;
		}
	}
}