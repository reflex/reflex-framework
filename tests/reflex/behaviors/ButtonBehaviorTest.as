package reflex.behaviors
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import mx.managers.SystemManager;
	
	import org.flexunit.asserts.assertEquals;
	
	import spark.components.Application;

	public class ButtonBehaviorTest extends EventDispatcher
	{
		
		[Bindable]
		public var currentState:String;
		
		public var stage:Stage;
		
		public function ButtonBehaviorTest() {
			//stage = ReflexSuite.stage;
		}
		
		[Test]
		public function testButtonStateUp():void {
			var behavior:ButtonBehavior = new ButtonBehavior(this);
			this.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, false));
			assertEquals("up", currentState);
		}
		
		[Test]
		public function testButtonStateOver():void {
			var behavior:ButtonBehavior = new ButtonBehavior(this);
			this.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, false));
			assertEquals("over", currentState);
		}
		
		[Test]
		public function testButtonStateDown():void {
			var behavior:ButtonBehavior = new ButtonBehavior(this);
			this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, false));
			assertEquals("down", currentState);
		}
		
		
		
	}
}