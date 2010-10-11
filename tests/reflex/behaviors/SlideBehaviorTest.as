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
	
	public class SlideBehaviorTest extends Shape
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
		
		/*
		
		// how do we test items based on mouseX/mouseY?
		
		[Test]
		public function testTrackClick():void { // default behavior (for sliders) should jump to position
			var behavior:SlideBehavior = new SlideBehavior(this);
			var position:IPosition = behavior.position = new Position(0, 100, 0);
			var event:MouseEvent = new MouseEvent(MouseEvent.CLICK, true, false, 70, 0, null, false, false, false, true, 0);
			var dispatcher:IEventDispatcher = skin.track;
			dispatcher.dispatchEvent(event);
			assertEquals(70, position.value);
		}
		
		[Test]
		public function testScrollTrackDownClick():void { // default behavior (for sliders) should jump to position
			var behavior:SlideBehavior = new SlideBehavior(this, SlideBehavior.HORIZONTAL, true);
			var position:IPosition = behavior.position = new ScrollPosition(0, 100, 0, 10);
			var event:MouseEvent = new MouseEvent(MouseEvent.CLICK, true, false, 100, 0, null, false, false, false, true, 0);
			var dispatcher:IEventDispatcher = skin.track;
			dispatcher.dispatchEvent(event);
			assertEquals(10, position.value);
		}
		
		
		[Test]
		public function testScrollTrackUpClick():void { // default behavior (for sliders) should jump to position
			var behavior:SlideBehavior = new SlideBehavior(this, SlideBehavior.HORIZONTAL, true);
			var position:IPosition = behavior.position = new ScrollPosition(0, 100, 100,1, 10);
			var event:MouseEvent = new MouseEvent(MouseEvent.CLICK, true, false, 0, 0, null, false, false, false, true, 0);
			var dispatcher:IEventDispatcher = skin.track;
			dispatcher.dispatchEvent(event);
			assertEquals(90, position.value);
		}
		*/
		/*
		[Test]
		public function testThumbScroll():void { //  not sure how to best do this
			
		}
		*/
		
	}
}