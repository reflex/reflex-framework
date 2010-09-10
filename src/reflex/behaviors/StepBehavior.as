package reflex.behaviors
{
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	
	import reflex.binding.Bind;
	import reflex.data.ISpan;
	import reflex.data.Span;
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
		public var position:ISpan = new Span();		// TODO: implement lazy instantiation of position
		
		public function StepBehavior(target:InteractiveObject = null)
		{
			super(target);
		}
		
		override public function set target(value:IEventDispatcher):void
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
		
		[EventListener(type="press", target="fwdBtn")]
		[EventListener(type="hold", target="fwdBtn")]
		public function onFwdPress(event:ButtonEvent):void
		{
			position.stepForward();
			event.updateAfterEvent();
		}
		
		[EventListener(type="press", target="bwdBtn")]
		[EventListener(type="hold", target="bwdBtn")]
		public function onBwdPress(event:ButtonEvent):void
		{
			position.stepBackward();
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