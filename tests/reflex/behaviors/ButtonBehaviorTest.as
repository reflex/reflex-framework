package reflex.behaviors
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import org.flexunit.asserts.assertEquals;
	
	import reflex.containers.Container;

	public class ButtonBehaviorTest extends EventDispatcher
	{
		
		[Test]
		public function testButtonStateUp():void {
			var behavior:ButtonBehavior = new ButtonBehavior(this);
			dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			assertEquals("up", behavior.currentState);
		}
		
		[Test]
		public function testButtonStateOver():void {
			var behavior:ButtonBehavior = new ButtonBehavior(this);
			dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			assertEquals("over", behavior.currentState);
		}
		
		[Test]
		public function testButtonStateDown():void {
			var behavior:ButtonBehavior = new ButtonBehavior(this);
			dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			assertEquals("down", behavior.currentState);
		}
		
	}
}