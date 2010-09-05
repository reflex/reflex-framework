package reflex.behaviors
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import org.flexunit.Assert;

	public class SelectableBehaviorTest extends EventDispatcher
	{
		
		[Bindable]
		public var selected:Boolean;
		
		[Test]
		public function testClick():void {
			this.selected = false;
			var selectable:SelectableBehavior = new SelectableBehavior(this);
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			Assert.assertTrue(this.selected);
		}
		
	}
}