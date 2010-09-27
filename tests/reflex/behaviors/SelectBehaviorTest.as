package reflex.behaviors
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import org.flexunit.Assert;

	public class SelectBehaviorTest extends EventDispatcher
	{
		
		[Test]
		public function testClick():void {
			var behavior:SelectBehavior = new SelectBehavior(this);
			dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			Assert.assertTrue(behavior.selected);
		}
		
	}
}