package reflex.components
{
	import reflex.tests.BaseClass;

	public class SliderDefinitionTest extends BaseClass
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