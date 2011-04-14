package reflex.components
{
	import reflex.tests.TestBase;

	public class SliderDefinitionTest extends TestBase
	{
		public function SliderDefinitionTest()
		{
		}
		
		[Test(async)]
		public function testPositionChange():void {
			testPropertyChange(SliderComponent, "position", new MockPosition());
		}
		
		[Test(async)]
		public function testPositionNotChanged():void {
			testPropertyNotChanged(SliderComponent, "position", new MockPosition());
		}
	}
}