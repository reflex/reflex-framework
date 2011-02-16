package reflex.containers {
	import flexunit.framework.Assert;
	
	import reflex.components.MockLayout;
	import reflex.display.StatefulContainerTestBase;
	import reflex.tests.TestBase;
	
	public class ContainerTest extends StatefulContainerTestBase {

		public function ContainerTest() {
			super();

			C = Container;
		}
		
		[Test]
		public function testSetStyleDeclaration():void {
			var testContainer:Container = new Container();
			testContainer.styleDeclaration = "testStyleDeclaration";

			Assert.assertEquals("testStyleDeclaration", testContainer.styleDeclaration);
		}
		
		[Test(async)]
		public function testTemplateChange():void {
			testPropertyChange(Container, "template", "testTemplate");
		}
		
		[Test(async)]
		public function testTemplateNotChanged():void {
			testPropertyNotChanged(Container, "template", "testTemplate");
		}

		[Test]
		public function testSetSize():void {
			var testContainer:Container = new Container();
			testContainer.setSize(20, 25);

			Assert.assertEquals(20, testContainer.width);
			Assert.assertEquals(25, testContainer.height);
		}
	}
}