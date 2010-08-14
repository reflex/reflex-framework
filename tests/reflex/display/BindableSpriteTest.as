package reflex.display
{
	import flash.events.Event;
	
	import flight.events.PropertyEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	import reflex.measurement.Measurements;
	
	public class BindableSpriteTest
	{
		
		[Test(async)]
		public function testXChange():void {
			var listener:Function = Async.asyncHandler(this, changeHandler, 1000, "xChange", timeoutHandler);
			var display:BindableSprite = new BindableSprite();
			display.addEventListener("xChange", listener, false, 0, false);
			display.x = 100;
			Assert.assertEquals(100, display.x);
		}
		
		[Test(async)]
		public function testYChange():void {
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "yChange", timeoutHandler);
			var display:BindableSprite = new BindableSprite();
			display.addEventListener("yChange", listener, false, 0, false);
			display.y = 100;
			Assert.assertEquals(100, display.y);
		}
		
		[Test(async)]
		public function testWidthChange():void {
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "widthChange", timeoutHandler);
			var display:BindableSprite= new BindableSprite();
			display.addEventListener("widthChange", listener, false, 0, false);
			display.width = 100;
			Assert.assertEquals(100, display.width);
		}
		
		[Test(async)]
		public function testHeightChange():void {
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "heightChange", timeoutHandler);
			var display:BindableSprite = new BindableSprite();
			display.addEventListener("heightChange", listener, false, 0, false);
			display.height = 100;
			Assert.assertEquals(100, display.height);
		}
		
		private function changeHandler(event:PropertyEvent, type:String):void {
			Assert.assertEquals(event.type, type);
		}
		
		private function timeoutHandler(type:String):void {
			Assert.fail(type + ": timed out.");
		}
	}
}