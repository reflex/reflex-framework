package reflex.components
{
	import flight.position.IPosition;
	
	import reflex.behaviors.SlideBehavior;
	import reflex.behaviors.StepBehavior;
	import reflex.skins.ScrollBarSkin;
	
	public class ScrollBar extends Component
	{
		[Bindable]
		public var position:IPosition;
		
		public function ScrollBar()
		{
		}
		
		/*override */protected function init():void
		{
			var scrollBarSkin:ScrollBarSkin = new ScrollBarSkin();
			skin = scrollBarSkin;
			var slideBehavior:SlideBehavior = new SlideBehavior(this);
			behaviors.slide = slideBehavior;
			var stepBehavior:StepBehavior = new StepBehavior(this);
			behaviors.step = stepBehavior;
//			position = scrollBarSkin.position = slideBehavior.position = stepBehavior.position;
		}
		
	}
}