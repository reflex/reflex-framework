package reflex.components
{
	import flight.position.IPosition;
	
	import legato.components.ScrollBarGraphic;
	
	import reflex.behaviors.SlideBehavior;
	import reflex.behaviors.StepBehavior;
	import reflex.skins.ScrollBarSkin;
	
	public class ScrollBar extends Component
	{
		[Bindable] public var position:IPosition;
		
		public function ScrollBar()
		{
			//skin = new ScrollBarGraphic();
			behaviors.slide = new SlideBehavior(this);
		}
		
		/*override */protected function init():void
		{
			//var scrollBarSkin:ScrollBarSkin = new ScrollBarSkin();
			skin = new ScrollBarGraphic();
			var slideBehavior:SlideBehavior = new SlideBehavior(this);
			behaviors.slide = slideBehavior;
			var stepBehavior:StepBehavior = new StepBehavior(this);
			behaviors.step = stepBehavior;
//			position = scrollBarSkin.position = slideBehavior.position = stepBehavior.position;
		}
		
	}
}