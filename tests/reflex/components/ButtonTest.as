package reflex.components
{
	import reflex.tests.TestBase;
	
	public class ButtonTest extends TestBase
	{
		
		[Test(async)]
		public function testLabelChange():void {
			testPropertyChange(ButtonDefinition, "label", "test");
		}
		
		[Test(async)]
		public function testLabelNotChanged():void {
			testPropertyNotChanged(ButtonDefinition, "label", "test");
		}
		
		[Test(async)]
		public function testSelectedChange():void {
			testPropertyChange(ButtonDefinition, "selected", true);
		}
		
		[Test(async)]
		public function testSelectedNotChanged():void {
			testPropertyNotChanged(ButtonDefinition, "selected", true);
		}
		
	}
}