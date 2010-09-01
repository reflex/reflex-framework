package reflex.measurement
{
	import org.flexunit.Assert;
	
	import reflex.display.Display;

	public class MeasurementFunctionsTest
	{
		
		[Test]
		public function testResolveWidthObject():void {
			var object:Object = {width: 100};
			var v:Number = reflex.measurement.resolveWidth(object);
			Assert.assertEquals(100, v);
		}
		
		[Test]
		public function testResolveWidthMeasured():void {
			var instance:IMeasurable = new Display();
			instance.measured.width = 100;
			var v:Number = reflex.measurement.resolveWidth(instance);
			Assert.assertEquals(100, v);
		}
		
		[Test]
		public function testResolveWidthExplicite():void {
			var instance:IMeasurable = new Display();
			instance.measured.width = 5;
			instance.explicite.width = 100;
			var v:Number = reflex.measurement.resolveWidth(instance);
			Assert.assertEquals(100, v);
		}
		
		[Test]
		public function testResolveHeightObject():void {
			var object:Object = {height: 100};
			var v:Number = reflex.measurement.resolveHeight(object);
			Assert.assertEquals(100, v);
		}
		
		[Test]
		public function testResolveHeightMeasured():void {
			var instance:IMeasurable = new Display();
			instance.measured.height = 100;
			var v:Number = reflex.measurement.resolveHeight(instance);
			Assert.assertEquals(100, v);
		}
		
		[Test]
		public function testResolveHeightExplicite():void {
			var instance:IMeasurable = new Display();
			instance.measured.height= 5;
			instance.explicite.height = 100;
			var v:Number = reflex.measurement.resolveHeight(instance);
			Assert.assertEquals(100, v);
		}
		
		[Test]
		public function testSetSizeObject():void {
			var object:Object = {};
			reflex.measurement.setSize(object, 100, 100);
			Assert.assertEquals(100, object.width);
			Assert.assertEquals(100, object.height);
		}
		
		[Test]
		public function testSetSizeMeasurable():void {
			var instance:IMeasurable = new Display();
			instance.measured.width = 5;
			instance.measured.height = 5;
			instance.explicite.width = 5;
			instance.explicite.height = 5;
			reflex.measurement.setSize(instance, 100, 100);
			Assert.assertEquals(100, instance.width);
			Assert.assertEquals(100, instance.height);
			Assert.assertEquals(5, instance.measured.width);
			Assert.assertEquals(5, instance.measured.height);
			Assert.assertEquals(5, instance.explicite.width);
			Assert.assertEquals(5, instance.explicite.height);
		}
		
	}
}