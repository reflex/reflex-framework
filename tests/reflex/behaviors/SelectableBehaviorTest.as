package reflex.behaviors
{
	import org.flexunit.Assert;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SelectableBehaviorTest
	{
		
		[Test]
		public function testClick():void {
			var sprite:Sprite = new Sprite();
			var selectable:SelectableBehavior = new SelectableBehavior(sprite);
			selectable.selected = false;
			sprite.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			Assert.assertTrue(selectable.selected);
		}
		
	}
}