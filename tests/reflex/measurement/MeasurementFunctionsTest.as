package reflex.measurement
{
	import mx.core.UIComponent;
	
	import org.flexunit.Assert;
	
	import reflex.display.MeasurableItem;

	public class MeasurementFunctionsTest
	{
		
		[Test]
		public function testResolveWidthObject():void {
			var object:Object = {width: 100};
			var v:Number = reflex.measurement.resolveWidth(object);
			Assert.assertEquals(100, v);
		}
		/*
		[Test]
		public function testResolveWidthMeasured():void {
			var instance:IMeasurable = new MeasurableItem();
			instance.measuredWidth = 100;
			var v:Number = reflex.measurement.resolveWidth(instance);
			Assert.assertEquals(100, v);
			new UIComponent
		}
		
		[Test]
		public function testResolveWidthexplicit():void {
			var instance:IMeasurable = new MeasurableItem();
			instance.measuredWidth = 5;
			instance.explicitWidth = 100;
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
			var instance:IMeasurable = new MeasurableItem();
			instance.measuredHeight = 100;
			var v:Number = reflex.measurement.resolveHeight(instance);
			Assert.assertEquals(100, v);
		}
		
		[Test]
		public function testResolveHeightexplicit():void {
			var instance:IMeasurable = new MeasurableItem();
			instance.measuredHeight= 5;
			instance.explicitHeight = 100;
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
			var instance:IMeasurable = new MeasurableItem();
			instance.measuredWidth = 5;
			instance.measuredHeight = 5;
			instance.explicitWidth = 5;
			instance.explicitHeight = 5;
			reflex.measurement.setSize(instance, 100, 100);
			Assert.assertEquals(100, instance.width);
			Assert.assertEquals(100, instance.height);
			Assert.assertEquals(5, instance.measuredWidth);
			Assert.assertEquals(5, instance.measuredHeight);
			Assert.assertEquals(5, instance.explicitWidth);
			Assert.assertEquals(5, instance.explicitHeight);
		}
		*/
	}
}