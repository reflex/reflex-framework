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
		
		/*
		[Test(async)]
		public function testExpliciteChange():void {
			var instance:IMeasurable = new C() as IMeasurable;
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "expliciteChange", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("expliciteChange", listener, false, 0, false);
			instance.explicite = new Measurements(this);
		}
		
		[Test(async)]
		public function testMeasuredChange():void {
			var instance:IMeasurable = new C() as IMeasurable;
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "measuredChange", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("measuredChange", listener, false, 0, false);
			instance.measured = new Measurements(this);
		}
		*/
		
		[Test(async)]
		public function testExpliciteWidth():void {
			var instance:IMeasurable = new C() as IMeasurable;
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "widthChange", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("widthChange", listener, false, 0, false);
			
			instance.width = 5;
			Assert.assertEquals(5, instance.width);
			Assert.assertEquals(5, instance.explicite.width);
		}
		
		[Test(async)]
		public function testExpliciteHeight():void {
			var instance:IMeasurable = new C() as IMeasurable;
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "heightChange", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("heightChange", listener, false, 0, false);
			
			instance.height = 5;
			Assert.assertEquals(5, instance.height);
			Assert.assertEquals(5, instance.explicite.height);
		}
		
		[Test(async)]
		public function testMeasuredWidth():void {
			var instance:IMeasurable = new C() as IMeasurable;
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "widthChange", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("widthChange", listener, false, 0, false);
			
			instance.measured.width = 5;
			Assert.assertEquals(5, instance.width);
			Assert.assertEquals(5, instance.measured.width);
		}
		
		[Test(async)]
		public function testMeasuredHeight():void {
			var instance:IMeasurable = new C() as IMeasurable;
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "heightChange", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("heightChange", listener, false, 0, false);
			
			instance.measured.height = 5;
			Assert.assertEquals(5, instance.height);
			Assert.assertEquals(5, instance.measured.height);
		}
		
		[Test(async)]
		public function testMeasuredWidthEvent():void {
			var instance:IMeasurable = new C() as IMeasurable;
			instance.width = 5; // there should be no change event for measured changes now
			Async.failOnEvent(this, instance as IEventDispatcher, "widthChange", 500);
			
			instance.measured.width = 100;
			Assert.assertEquals(5, instance.width);
			Assert.assertEquals(5, instance.explicite.width);
		}
		
		[Test(async)]
		public function testMeasuredHeightEvent():void {
			var instance:IMeasurable = new C() as IMeasurable;
			instance.height = 5; // there should be no change event for measured changes now
			Async.failOnEvent(this, instance as IEventDispatcher, "heightChange", 500);
			
			instance.measured.height = 100;
			Assert.assertEquals(5, instance.height);
			Assert.assertEquals(5, instance.explicite.height);
		}
		/*
		[Test(async)]
		public function testPercentWidth():void {
			var instance:IMeasurablePercent = new C() as IMeasurablePercent;
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "percentWidthChange", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("percentWidthChange", listener, false, 0, false);
			
			instance.percentWidth = 75;
			Assert.assertEquals(75, instance.percentWidth);
		}
		
		[Test(async)]
		public function testPercentHeight():void {
			var instance:IMeasurablePercent = new C() as IMeasurablePercent;
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "percentHeightChange", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("percentHeightChange", listener, false, 0, false);
			
			instance.percentHeight = 75;
			Assert.assertEquals(75, instance.percentHeight);
		}
		*/
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
			Assert.assertFalse(instance.explicite.width == 5);
			Assert.assertFalse(instance.explicite.height == 5);
		}
		
		private function changeHandler(event:Event, type:String):void {
			Assert.assertEquals(event.type, type);
		}
		
		private function timeoutHandler(type:String):void {
			Assert.fail(type + ": timed out.");
		}
		
	}
}