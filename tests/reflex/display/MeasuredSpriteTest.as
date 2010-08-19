package reflex.display
{
	import reflex.measurement.MeasurableTestBase;

	public class MeasuredSpriteTest extends MeasurableTestBase
	{
		
		public function MeasuredSpriteTest()
		{
			super();
			C = MeasuredSprite;
		}
		
		
		[Test(async)]
		public function testPercentWidthChange():void {
			testPropertyChange(C, "percentWidth", 100);
		}
		
		[Test(async)]
		public function testPercentWidthNotChanged():void {
			testPropertyNotChanged(C, "percentWidth", 100);
		}
		
		[Test(async)]
		public function testPercentHeightChange():void {
			testPropertyChange(C, "percentHeight", 100);
		}
		
		[Test(async)]
		public function testPercentHeightNotChanged():void {
			testPropertyNotChanged(C, "percentHeight", 100);
		}
		
	}
}