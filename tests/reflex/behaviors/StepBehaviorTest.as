package reflex.behaviors
{
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.flexunit.asserts.assertEquals;
	
	import reflex.data.IPosition;
	import reflex.data.Position;
	import reflex.data.ScrollPosition;
	
	public class StepBehaviorTest extends EventDispatcher
	{
		
		//public var stage:Stage;
		
		[Bindable]
		public var skin:MockSlider;
		
		[Before]
		public function setup():void {
			skin = new MockSlider();
			//stage.addChild(skin);
		}
		
		[After]
		public function destroy():void {
			//stage.removeChild(skin);
			skin = null;
		}
		
		[Test]
		public function testIncrementButtonClick():void { // default behavior (for sliders) should jump to position
			var behavior:StepBehavior= new StepBehavior(this);
			var position:IPosition = behavior.position = new Position(0, 100, 0, 1);
			var event:MouseEvent = new MouseEvent(MouseEvent.CLICK, true, false, 0, 0, null, false, false, false, true, 0);
			var dispatcher:IEventDispatcher = skin.incrementButton;
			dispatcher.dispatchEvent(event);
			assertEquals(1, position.value);
		}
		
		[Test]
		public function testDecrementButtonClick():void { // default behavior (for sliders) should jump to position
			var behavior:StepBehavior = new StepBehavior(this);
			var position:IPosition = behavior.position = new Position(0, 100, 100, 1);
			var event:MouseEvent = new MouseEvent(MouseEvent.CLICK, true, false, 0, 0, null, false, false, false, true, 0);
			var dispatcher:IEventDispatcher = skin.decrementButton;
			dispatcher.dispatchEvent(event);
			assertEquals(99, position.value);
		}
		
		
	}
}