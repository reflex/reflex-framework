package reflex.components
{
	import flexunit.framework.Assert;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import reflex.collections.SimpleCollection;
	import reflex.containers.ContainerTestBase;
	import reflex.tests.BaseClass;
	
	public class ScrollerDefinitionTest extends ContainerTestBase
	{
		public function ScrollerDefinitionTest() {
			super();
			C = Scroller;
		}
		
		[Test(async)]
		public function testHorizontalPositionChange():void {
			testPropertyChange(Scroller, "horizontalPosition", new MockPosition());
		}
		
		[Test(async)]
		public function testHorizontalPositionNotChanged():void {
			testPropertyNotChanged(Scroller, "horizontalPosition", new MockPosition());
		}
		
		[Test(async)]
		public function testVerticalPositionChange():void {
			testPropertyChange(Scroller, "verticalPosition", new MockPosition());
		}
		
		[Test(async)]
		public function testVerticalPositionNotChanged():void {
			testPropertyNotChanged(Scroller, "verticalPosition", new MockPosition());
		}
	}
}