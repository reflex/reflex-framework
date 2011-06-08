package reflex.data {
	import flexunit.framework.Assert;
	
	import reflex.tests.BaseClass;

	public class PositionTest extends BaseClass {

		public function PositionTest() {
		}
		
		[Test(async)]
		public function testValueChange():void {
			testPropertyChange(Position, "value", 10);
		}
		
		[Test(async)]
		public function testValueNotChanged():void {
			testPropertyNotChanged(Position, "value", 10);
		}
		
		[Test(async)]
		public function testStepSizeChange():void {
			testPropertyChange(Position, "stepSize", 10);
		}
		
		[Test(async)]
		public function testStepSizeNotChanged():void {
			testPropertyNotChanged(Position, "stepSize", 10);
		}

		[Test]
		public function testPositionConstructor():void {
			var position:Position = new Position(10, 90, 20, 5);

			Assert.assertEquals(10, position.minimum);
			Assert.assertEquals(90, position.maximum);
			Assert.assertEquals(20, position.value);
			Assert.assertEquals(5, position.stepSize);
		}
		
		[Test]
		public function testDefaultPositionConstructor():void {
			var position:Position = new Position();
			
			Assert.assertEquals(0, position.minimum);
			Assert.assertEquals(100, position.maximum);
			Assert.assertEquals(0, position.value);
			Assert.assertEquals(1, position.stepSize);
		}
	}
}