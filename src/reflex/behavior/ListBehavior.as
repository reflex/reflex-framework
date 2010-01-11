package reflex.behavior
{
	import flash.display.InteractiveObject;
	
	import reflex.core.ISkin;
	import reflex.core.ISkinnable;

	public class ListBehavior extends Behavior
	{
		public var hScrollBar:InteractiveObject;
		public var vScrollBar:InteractiveObject;
		
		private var hScrollBehavior:ScrollBehavior;
		private var vScrollBehavior:ScrollBehavior;
		
		public function ListBehavior()
		{
		}
		
		override public function set target(value:InteractiveObject):void
		{
			super.target = value;
			
			if (target == null) {
				return;
			}
			
			var skin:ISkin = ISkinnable(target).skin;
			
			hScrollBar = getSkinPart('hScrollBar');
			vScrollBar = getSkinPart('vScrollBar');
			
			hScrollBehavior = new ScrollBehavior();
			vScrollBehavior = new ScrollBehavior();
			
			hScrollBehavior.target = hScrollBar;
			vScrollBehavior.target = vScrollBar;
			
		}
	}
}