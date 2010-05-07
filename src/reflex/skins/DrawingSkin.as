package reflex.skins
{
	import flash.display.Graphics;
	
	import flight.binding.Bind;
	
	import reflex.events.InvalidationEvent;

	public class DrawingSkin extends Skin
	{
		
		static public const DRAW:String = "draw";
		
		InvalidationEvent.registerPhase(DRAW);
		
		public function DrawingSkin()
		{
			Bind.addListener(this, invalidateRedraw, this, "target");
			Bind.addListener(this, invalidateRedraw, this, "state");
			Bind.addListener(this, invalidateRedraw, this, "target.width");
			Bind.addListener(this, invalidateRedraw, this, "target.height");
			Bind.bindEventListener(DRAW, onDraw, this, "target");
		}
		
		public function invalidateRedraw():void
		{
			if (target) {
				InvalidationEvent.invalidate(target, DRAW);
			}
		}
		
		public function redraw(graphics:Graphics):void
		{
		}
		
		protected function onDraw(event:InvalidationEvent):void
		{
			if (target != null) {
				redraw(target.graphics);
			}
		}
	}
}