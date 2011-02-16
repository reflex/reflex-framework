package reflex.components
{
	import flexunit.framework.Assert;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import reflex.collections.SimpleCollection;
	import reflex.containers.ContainerTestBase;
	import reflex.tests.TestBase;
	
	public class ScrollerDefinitionTest extends ContainerTestBase
	{
		public function ScrollerDefinitionTest() {
			super();
			C = ScrollerDefinition;
		}
		
		[Test(async)]
		public function testHorizontalPositionChange():void {
			testPropertyChange(ScrollerDefinition, "horizontalPosition", new MockPosition());
		}
		
		[Test(async)]
		public function testHorizontalPositionNotChanged():void {
			testPropertyNotChanged(ScrollerDefinition, "horizontalPosition", new MockPosition());
		}
		
		[Test(async)]
		public function testVerticalPositionChange():void {
			testPropertyChange(ScrollerDefinition, "verticalPosition", new MockPosition());
		}
		
		[Test(async)]
		public function testVerticalPositionNotChanged():void {
			testPropertyNotChanged(ScrollerDefinition, "verticalPosition", new MockPosition());
		}
	}
}