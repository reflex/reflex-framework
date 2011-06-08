package reflex.data {
	import flexunit.framework.Assert;
	
	import reflex.tests.BaseClass;

	public class ScrollPositionTest extends BaseClass {

		public function ScrollPositionTest() {
		}
		
		[Test(async)]
		public function testPageSizeChange():void {
			testPropertyChange(ScrollPosition, "pageSize", 20);
		}
		
		[Test(async)]
		public function testPageSizeNotChanged():void {
			testPropertyNotChanged(ScrollPosition, "pageSize", 20);
		}
		
		[Test]
		public function testScrollPositionConstructor():void {
			var scrollPosition:ScrollPosition = new ScrollPosition(10, 90, 20, 5, 15);
			
			Assert.assertEquals(10, scrollPosition.minimum);
			Assert.assertEquals(90, scrollPosition.maximum);
			Assert.assertEquals(20, scrollPosition.value);
			Assert.assertEquals(5, scrollPosition.stepSize);
			Assert.assertEquals(15, scrollPosition.pageSize);
		}
		
		[Test]
		public function testDefaultScrollPositionConstructor():void {
			var scrollPosition:ScrollPosition = new ScrollPosition();
			
			Assert.assertEquals(0, scrollPosition.minimum);
			Assert.assertEquals(100, scrollPosition.maximum);
			Assert.assertEquals(0, scrollPosition.value);
			Assert.assertEquals(1, scrollPosition.stepSize);
			Assert.assertEquals(10, scrollPosition.pageSize);
		}
	}
}