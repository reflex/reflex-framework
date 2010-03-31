package reflex.skins
{
	import flash.display.Graphics;
	
	import flight.binding.Bind;
	
	import reflex.events.RenderEvent;

	public class DrawingSkin extends Skin
	{
		RenderEvent.registerPhase(DRAW);
		
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
				RenderEvent.invalidate(target, DRAW);
			}
		}
		
		public function redraw(graphics:Graphics):void
		{
		}
		
		protected function onDraw(event:RenderEvent):void
		{
			if (target != null) {
				redraw(target.graphics);
			}
		}
	}
}