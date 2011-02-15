package reflex.containers {
	import flexunit.framework.Assert;
	
	import reflex.components.MockLayout;
	import reflex.tests.TestBase;
	
	public class ContainerTest extends TestBase {

		public function ContainerTest() {
			super();
		}
		
		[Test(async)]
		public function testStatesChange():void {
			testPropertyChange(Container, "states", new Array());
		}
		
		[Test(async)]
		public function testStatesNotChanged():void {
			testPropertyNotChanged(Container, "states", new Array());
		}
		
		[Test(async)]
		public function testTransitionsChange():void {
			testPropertyChange(Container, "transitions", new Array());
		}
		
		[Test(async)]
		public function testTransitionsNotChanged():void {
			testPropertyNotChanged(Container, "transitions", new Array());
		}
		
		[Test(async)]
		public function testCurrentStateChange():void {
			testPropertyChange(Container, "currentState", "testState");
		}
		
		[Test(async)]
		public function testCurrentStateNotChanged():void {
			testPropertyNotChanged(Container, "currentState", "testState");
		}

		[Test]
		public function testHasState():void {
			var testContainer:Container = new Container();
			testContainer.states = createTestStates();

			Assert.assertTrue(testContainer.hasState("name1"));
			Assert.assertFalse(testContainer.hasState("nonExistingStateName"));
		}

		private function createTestStates():Array {
			var state1:Object = new Object();
			var state2:Object = new Object();
			var state3:Object = new Object();
			
			state1["name"] = "name1";
			state2["name"] = "name2";
			state3["name"] = "name3";

			var testStates:Array = [state1, state2, state3];

			return testStates;
		}
		
		[Test]
		public function testSetStyleDeclaration():void {
			var testContainer:Container = new Container();
			testContainer.styleDeclaration = "testStyleDeclaration";

			Assert.assertEquals("testStyleDeclaration", testContainer.styleDeclaration);
		}
		
		[Test(async)]
		public function testLayoutChange():void {
			testPropertyChange(Container, "layout", new MockLayout());
		}
		
		[Test(async)]
		public function testLayoutNotChanged():void {
			testPropertyNotChanged(Container, "layout", new MockLayout());
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