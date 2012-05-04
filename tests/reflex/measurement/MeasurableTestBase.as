package reflex.measurement
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	import reflex.tests.BaseClass;
	

	public class MeasurableTestBase extends BaseClass
	{
		
		public var C:Class;
		
		[Test(order=-1)]
		public function testIMeasurable():void {
			var instance:Object = new C();
			Assert.assertTrue(instance is IMeasurable);
			Assert.assertTrue(instance is IEventDispatcher);
		}
		
		[Test]
		public function testDefaultSize():void {
			var instance:IMeasurable = new C();
			//Assert.assertNotNull(instance.explicit);
			//Assert.assertNotNull(instance.measured);
			Assert.assertFalse(isNaN(instance.measuredWidth));
			Assert.assertFalse(isNaN(instance.measuredHeight));
			Assert.assertTrue(isNaN(instance.explicitWidth));
			Assert.assertTrue(isNaN(instance.explicitHeight));
		}
		
		[Test(async)]
		public function testWidthChange():void {
			testPropertyChange(C, "width", 100);
		}
		
		[Test(async)]
		public function testWidthNotChanged():void {
			testPropertyNotChanged(C, "width", 100);
		}
		
		[Test(async)]
		public function testHeightChange():void {
			testPropertyChange(C, "height", 100);
		}
		
		[Test(async)]
		public function testHeightNotChanged():void {
			testPropertyNotChanged(C, "height", 100);
		}
		
		[Test]
		public function testexplicitWidth():void {
			var instance:IMeasurable = new C() as IMeasurable;
			instance.width = 100;
			Assert.assertEquals(100, instance.width);
			Assert.assertEquals(100, instance.explicitWidth);
		}
		
		[Test]
		public function testexplicitHeight():void {
			var instance:IMeasurable = new C() as IMeasurable;
			instance.height = 100;
			Assert.assertEquals(100, instance.height);
			Assert.assertEquals(100, instance.explicitHeight);
		}
		/*
		[Test(async)]
		public function testMeasuredWidth():void {
			var instance:IMeasurable = new C() as IMeasurable;
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "widthChange", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("widthChange", listener, false, 0, false);
			
			instance.measuredWidth = 100;
			Assert.assertEquals(100, instance.width);
			Assert.assertEquals(100, instance.measuredWidth);
		}
		
		[Test(async)]
		public function testMeasuredHeight():void {
			var instance:IMeasurable = new C() as IMeasurable;
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "heightChange", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("heightChange", listener, false, 0, false);
			
			instance.measuredHeight = 100;
			Assert.assertEquals(100, instance.height);
			Assert.assertEquals(100, instance.measuredHeight);
		}
		
		[Test(async)]
		public function testMeasuredWidthEvent():void {
			var instance:IMeasurable = new C() as IMeasurable;
			instance.width = 100; // there should be no change event for measured changes now
			Async.failOnEvent(this, instance as IEventDispatcher, "widthChange", 500);
			
			instance.measuredWidth = 5;
			Assert.assertEquals(100, instance.width);
			Assert.assertEquals(100, instance.explicitWidth);
		}
		
		[Test(async)]
		public function testMeasuredHeightEvent():void {
			var instance:IMeasurable = new C() as IMeasurable;
			instance.height = 100; // there should be no change event for measured changes now
			Async.failOnEvent(this, instance as IEventDispatcher, "heightChange", 500);
			
			instance.measured.height = 5;
			Assert.assertEquals(100, instance.height);
			Assert.assertEquals(100, instance.explicitHeight);
		}
		*/
		[Test(async)] // binding events should fire for width/height changes, but explicit/measured should not be updated
		public function testSetSize():void {
			var instance:IMeasurable = new C() as IMeasurable;
			var widthListener:Function = Async.asyncHandler(this, changeHandler, 500, "widthChange", timeoutHandler);
			var heightListener:Function = Async.asyncHandler(this, changeHandler, 500, "heightChange", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("widthChange", widthListener, false, 0, false);
			(instance as IEventDispatcher).addEventListener("heightChange", heightListener, false, 0, false);
			
			instance.setSize(100, 100);
			Assert.assertEquals(100, instance.width);
			Assert.assertEquals(100, instance.height);
			Assert.assertFalse(instance.explicitWidth == 100);
			Assert.assertFalse(instance.explicitHeight == 100);
		}
		
		[Test(async)] //  no events should fire if size hasn't changed
		public function testSetSizeNotChanged():void {
			var instance:IMeasurable = new C() as IMeasurable;
			instance.setSize(100, 100);
			Async.failOnEvent(this, instance as IEventDispatcher, "widthChange", 500, timeoutHandler);
			Async.failOnEvent(this, instance as IEventDispatcher, "heightChange", 500, timeoutHandler);
			instance.setSize(100, 100);
		}
		
		
	}
}