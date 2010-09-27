package reflex.components
{
	import reflex.collections.SimpleCollection;
	import reflex.data.Range;
	import reflex.layouts.XYLayout;
	import reflex.tests.TestBase;
	
	public class ListTest extends TestBase
	{
		
		[Test(async)]
		public function testDataProviderChange():void {
			testPropertyChange(ListDefinition, "dataProvider", new SimpleCollection());
		}
		
		[Test(async)]
		public function testDataProviderNotChanged():void {
			testPropertyNotChanged(ListDefinition, "dataProvider", new SimpleCollection());
		}
		
		[Test(async)]
		public function testTemplateChange():void {
			testPropertyChange(ListDefinition, "template", {});
		}
		
		[Test(async)]
		public function testTemplateNotChanged():void {
			testPropertyNotChanged(ListDefinition, "template", {});
		}
		
		[Test(async)]
		public function testLayoutChange():void {
			testPropertyChange(ListDefinition, "layout", new XYLayout());
		}
		
		[Test(async)]
		public function testLayoutNotChanged():void {
			testPropertyNotChanged(ListDefinition, "layout", new XYLayout());
		}
		
		[Test(async)]
		public function testPositionChange():void {
			testPropertyChange(ListDefinition, "position", new Range());
		}
		
		[Test(async)]
		public function testPositionNotChanged():void {
			testPropertyNotChanged(ListDefinition, "position", new Range());
		}
		
	}
}