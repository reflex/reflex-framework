package reflex.behaviors
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	import org.flexunit.asserts.assertEquals;
	
	import reflex.display.Container;

	public class ButtonBehaviorTest
	{
		
		public var stage:Stage;
		public var display:Container;
		
		public function ButtonBehaviorTest() {
			stage = ReflexSuite.stage;
			display = new Container()
		}
		
		[Before]
		public function setup():void {
			var behavior:ButtonBehavior = new ButtonBehavior(display);
			stage.addChild(display);
		}
		
		[After]
		public function destroy():void {
			stage.removeChild(display);
		}
		
		[Test]
		public function testButtonStateUp():void {
			display.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, true));
			assertEquals("up", display.currentState);
		}
		
		[Test]
		public function testButtonStateOver():void {
			display.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true));
			assertEquals("over", display.currentState);
		}
		
		[Test]
		public function testButtonStateDown():void {
			display.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true));
			assertEquals("down", display.currentState);
		}
		
		
		
	}
}