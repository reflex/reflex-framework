package reflex.measurement
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	

	public class MeasurableTestBase extends EventDispatcher
	{
		
		public var C:Class;
		
		[Test(order=-1)]
		public function testIMeasurable():void {
			var instance:Object = new C();
			Assert.assertTrue(instance is IMeasurable);
			Assert.assertTrue(instance is IEventDispatcher);
		}
		
		[Test(async)]
		public function testExpliciteWidth():void {
			var instance:IMeasurable = new C() as IMeasurable;
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "widthChange", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("widthChange", listener, false, 0, false);
			
			instance.width = 5;
			Assert.assertEquals(5, instance.width);
			Assert.assertEquals(5, instance.measurements.expliciteWidth);
		}
		
		[Test(async)]
		public function testExpliciteHeight():void {
			var instance:IMeasurable = new C() as IMeasurable;
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "heightChange", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("heightChange", listener, false, 0, false);
			
			instance.height = 5;
			Assert.assertEquals(5, instance.height);
			Assert.assertEquals(5, instance.measurements.expliciteHeight);
		}
		
		[Test(async)]
		public function testSetSize():void {
			var instance:IMeasurable = new C() as IMeasurable;
			var widthListener:Function = Async.asyncHandler(this, changeHandler, 500, "widthChange", timeoutHandler);
			var heightListener:Function = Async.asyncHandler(this, changeHandler, 500, "heightChange", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("widthChange", widthListener, false, 0, false);
			(instance as IEventDispatcher).addEventListener("heightChange", heightListener, false, 0, false);
			
			instance.setSize(5, 5);
			Assert.assertEquals(5, instance.width);
			Assert.assertEquals(5, instance.height);
			Assert.assertFalse(instance.measurements.expliciteWidth == 5);
			Assert.assertFalse(instance.measurements.expliciteHeight == 5);
		}
		
		private function changeHandler(event:Event, type:String):void {
			Assert.assertEquals(event.type, type);
		}
		
		private function timeoutHandler(type:String):void {
			Assert.fail(type + ": timed out.");
		}
		
	}
}