package reflex.components
{
	import flight.list.ArrayList;
	import flight.position.Position;
	
	import reflex.display.ReflexDataTemplate;
	import reflex.layouts.XYLayout;
	import reflex.tests.TestBase;
	
	public class ListTest extends TestBase
	{
		
		[Test(async)]
		public function testDataProviderChange():void {
			testPropertyChange(List, "dataProvider", new ArrayList());
		}
		
		[Test(async)]
		public function testDataProviderNotChanged():void {
			testPropertyNotChanged(List, "dataProvider", new ArrayList());
		}
		
		[Test(async)]
		public function testTemplateChange():void {
			testPropertyChange(List, "template", new ReflexDataTemplate());
		}
		
		[Test(async)]
		public function testTemplateNotChanged():void {
			testPropertyNotChanged(List, "template", new ReflexDataTemplate());
		}
		
		[Test(async)]
		public function testLayoutChange():void {
			testPropertyChange(List, "layout", new XYLayout());
		}
		
		[Test(async)]
		public function testLayoutNotChanged():void {
			testPropertyNotChanged(List, "layout", new XYLayout());
		}
		
		[Test(async)]
		public function testPositionChange():void {
			testPropertyChange(List, "position", new Position());
		}
		
		[Test(async)]
		public function testPositionNotChanged():void {
			testPropertyNotChanged(List, "position", new Position());
		}
		
	}
}