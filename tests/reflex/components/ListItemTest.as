package reflex.components
{
	import reflex.tests.TestBase;

	public class ListItemTest extends TestBase
	{
		
		[Test(async)]
		public function testDataChange():void {
			testPropertyChange(ListItemDefinition, "data", "test");
		}
		
		[Test(async)]
		public function testDataNotChanged():void {
			testPropertyNotChanged(ListItemDefinition, "data", "test");
		}
		
	}
}