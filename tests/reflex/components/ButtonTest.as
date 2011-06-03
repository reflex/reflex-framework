package reflex.components
{
	import reflex.tests.BaseClass;
	
	public class ButtonTest extends BaseClass
	{
		
		[Test(async)]
		public function testLabelChange():void {
			testPropertyChange(Button, "label", "test");
		}
		
		[Test(async)]
		public function testLabelNotChanged():void {
			testPropertyNotChanged(Button, "label", "test");
		}
		
		[Test(async)]
		public function testSelectedChange():void {
			testPropertyChange(Button, "selected", true);
		}
		
		[Test(async)]
		public function testSelectedNotChanged():void {
			testPropertyNotChanged(Button, "selected", true);
		}
		
	}
}