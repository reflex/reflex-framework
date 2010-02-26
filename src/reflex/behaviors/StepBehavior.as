package reflex.behaviors
{
	import flash.display.InteractiveObject;
	
	import flight.position.IPosition;
	import flight.position.Position;
	
	import reflex.events.ButtonEvent;
	
	public class StepBehavior extends Behavior
	{
		public var fwdBtn:InteractiveObject;
		public var bwdBtn:InteractiveObject;
		
		[Bindable]
		[Binding(target="target.position")]
		public var position:IPosition = new Position();		// TODO: implement lazy instantiation of position
		
		public function StepBehavior(target:InteractiveObject = null)
		{
			super(target);
		}
		
		override public function set target(value:InteractiveObject):void
		{
			super.target = value;
			
			if (target == null) {
				return;
			}
			
			fwdBtn = getSkinPart("fwdBtn");
			bwdBtn = getSkinPart("bwdBtn");
			ButtonEvent.initialize(fwdBtn);
			ButtonEvent.initialize(bwdBtn);
		}
		
		[EventListener(type="press", target="fwdBtn")]
		[EventListener(type="hold", target="fwdBtn")]
		public function onFwdPress(event:ButtonEvent):void
		{
			position.forward();
			event.updateAfterEvent();
		}
		
		[EventListener(type="press", target="bwdBtn")]
		[EventListener(type="hold", target="bwdBtn")]
		public function onBwdPress(event:ButtonEvent):void
		{
			position.backward();
			event.updateAfterEvent();
		}
		
		
	}
}