package reflex.behaviors
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import org.flexunit.Assert;

	public class SelectableBehaviorTest extends EventDispatcher
	{
		
		[Test]
		public function testClick():void {
			var selectable:SelectableBehavior = new SelectableBehavior(this);
			selectable.selected = false;
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			Assert.assertTrue(selectable.selected);
		}
		
	}
}