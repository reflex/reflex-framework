package reflex.data {
	import flexunit.framework.Assert;
	
	import reflex.tests.BaseClass;

	public class RangeTest extends BaseClass {

		public function RangeTest() {
		}
		
		[Test(async)]
		public function testMinimumChange():void {
			testPropertyChange(Range, "minimum", 10);
		}
		
		[Test(async)]
		public function testMinimumNotChanged():void {
			testPropertyNotChanged(Range, "minimum", 10);
		}
		
		[Test(async)]
		public function testMaximumChange():void {
			testPropertyChange(Range, "maximum", 10);
		}
		
		[Test(async)]
		public function testMaximumNotChanged():void {
			testPropertyNotChanged(Range, "maximum", 10);
		}
		
		[Test]
		public function testRangeConstructor():void {
			var range:Range = new Range(10, 90);
			
			Assert.assertEquals(10, range.minimum);
			Assert.assertEquals(90, range.maximum);
		}
		
		[Test]
		public function testDefaultRangeConstructor():void {
			var range:Range = new Range();
			
			Assert.assertEquals(0, range.minimum);
			Assert.assertEquals(100, range.maximum);
		}
	}
}