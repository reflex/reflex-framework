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
			testPropertyChange(SliderDefinition, "position", new MockPosition());
		}
		
		[Test(async)]
		public function testPositionNotChanged():void {
			testPropertyNotChanged(SliderDefinition, "position", new MockPosition());
		}
	}
}