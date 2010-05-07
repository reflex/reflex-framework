package reflex.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;
	
	import reflex.skins.ISkin;
	import reflex.skins.ISkinnable;

	public class ListBehavior extends Behavior
	{
		public var hScrollBar:InteractiveObject;
		public var vScrollBar:InteractiveObject;
		
		private var hSlideBehavior:SlideBehavior;
		private var vSlideBehavior:SlideBehavior;
		
		public function ListBehavior()
		{
		}
		
		override public function set target(value:IEventDispatcher):void
		{
			super.target = value;
			
			if (target == null) {
				return;
			}
			
			//var skin:ISkin = ISkinnable(target).skin;
			
			hScrollBar = getSkinPart('hScrollBar');
			vScrollBar = getSkinPart('vScrollBar');
			
			hSlideBehavior = new SlideBehavior();
			vSlideBehavior = new SlideBehavior();
			
			hSlideBehavior.target = hScrollBar;
			vSlideBehavior.target = vScrollBar;
			
		}
	}
}