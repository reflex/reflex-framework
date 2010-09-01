package reflex.components
{
	import reflex.collections.SimpleCollection;
	import reflex.data.Position;
	
	import reflex.layouts.XYLayout;
	import reflex.tests.TestBase;
	
	public class ListTest extends TestBase
	{
		
		[Test(async)]
		public function testDataProviderChange():void {
			testPropertyChange(List, "dataProvider", new SimpleCollection());
		}
		
		[Test(async)]
		public function testDataProviderNotChanged():void {
			testPropertyNotChanged(List, "dataProvider", new SimpleCollection());
		}
		
		[Test(async)]
		public function testTemplateChange():void {
			testPropertyChange(List, "template", {});
		}
		
		[Test(async)]
		public function testTemplateNotChanged():void {
			testPropertyNotChanged(List, "template", {});
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