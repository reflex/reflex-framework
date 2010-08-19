package reflex.components
{
	import reflex.tests.TestBase;
	
	public class ListItemTest extends TestBase
	{
		
		[Test(async)]
		public function testDataChange():void {
			testPropertyChange(ListItem, "data", {});
		}
		
		[Test(async)]
		public function testDataNotChanged():void {
			testPropertyNotChanged(ListItem, "data", {});
		}
		
	}
}