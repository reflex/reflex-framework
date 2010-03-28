package reflex.behaviors
{
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	
	import flight.binding.Bind;
	import flight.position.IPosition;
	import flight.position.Position;
	
	import reflex.events.ButtonEvent;
	
	public class StepBehavior extends Behavior
	{
		public var fwdBehavior:ButtonBehavior;
		public var bwdBehavior:ButtonBehavior;
		
		[Bindable]
		public var fwdBtn:InteractiveObject;
		[Bindable]
		public var bwdBtn:InteractiveObject;
		
		[Bindable]
		[Binding(target="target.position")]
		public var position:IPosition = new Position();		// TODO: implement lazy instantiation of position
		
		public function StepBehavior(target:InteractiveObject = null)
		{
			super(target);
			bindProperty("position", "target.position");
			bindEventListener("press", onFwdPress, "fwdBtn");
			bindEventListener("hold", onFwdPress, "fwdBtn");
			bindEventListener("press", onBwdPress, "bwdBtn");
			bindEventListener("hold", onBwdPress, "bwdBtn");
		}
		
		override public function set target(value:InteractiveObject):void
		{
			super.target = value;
			
			if (target == null) {
				return;
			}
			
			fwdBtn = getSkinPart("fwdBtn");
			bwdBtn = getSkinPart("bwdBtn");
			fwdBehavior = new ButtonBehavior(fwdBtn);
			bwdBehavior = new ButtonBehavior(bwdBtn);
			if (fwdBtn is MovieClip) {
				Bind.addListener(this, onFwdStateChange, fwdBehavior, "state");
			}
			if (bwdBtn is MovieClip) {
				Bind.addListener(this, onBwdStateChange, bwdBehavior, "state");
			}
		}
		
		protected function onFwdPress(event:ButtonEvent):void
		{
			position.forward();
			event.updateAfterEvent();
		}
		
		protected function onBwdPress(event:ButtonEvent):void
		{
			position.backward();
			event.updateAfterEvent();
		}
		
		protected function onFwdStateChange(state:String):void
		{
			MovieClip(fwdBtn).gotoAndStop(state);
		}
		
		protected function onBwdStateChange(state:String):void
		{
			MovieClip(bwdBtn).gotoAndStop(state);
		}
	}
}