package reflex.display
{
	import flash.events.Event;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	import reflex.measurement.Measurements;
	
	public class ReflexDisplayTest
	{
		
		[Test(async)]
		public function testXChange():void {
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "xChange", timeoutHandler);
			var display:ReflexDisplay = new ReflexDisplay();
			display.addEventListener("xChange", listener, false, 0, false);
			display.x += 100;
		}
		
		[Test(async)]
		public function testYChange():void {
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "yChange", timeoutHandler);
			var display:ReflexDisplay = new ReflexDisplay();
			display.addEventListener("yChange", listener, false, 0, false);
			display.y += 100;
		}
		
		[Test(async)]
		public function testWidthChange():void {
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "widthChange", timeoutHandler);
			var display:ReflexDisplay = new ReflexDisplay();
			display.addEventListener("widthChange", listener, false, 0, false);
			display.width += 100;
		}
		
		[Test(async)]
		public function testHeightChange():void {
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "heightChange", timeoutHandler);
			var display:ReflexDisplay = new ReflexDisplay();
			display.addEventListener("heightChange", listener, false, 0, false);
			display.height += 100;
		}
		
		[Test(async)]
		public function testMeasurementsChange():void {
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "measurementsChange", timeoutHandler);
			var display:ReflexDisplay = new ReflexDisplay();
			display.addEventListener("measurementsChange", listener, false, 0, false);
			display.measurements = new Measurements();
		}
		
		private function changeHandler(event:Event, type:String):void {
			Assert.assertEquals(event.type, type);
		}
		
		private function timeoutHandler(type:String):void {
			Assert.fail(type + ": timed out.");
		}
	}
}