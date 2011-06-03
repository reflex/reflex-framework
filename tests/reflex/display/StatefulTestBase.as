package reflex.display
{
	import flexunit.framework.Assert;
	
	import reflex.components.IStateful;
	import reflex.tests.BaseClass;

	public class StatefulTestBase extends BaseClass
	{
		
		public var C:Class;
		
		[Test(async)]
		public function testStatesChange():void {
			testPropertyChange(C, "states", []);
		}
		
		[Test(async)]
		public function testStatesNotChanged():void {
			testPropertyNotChanged(C, "states", []);
		}
		
		[Test(async)]
		public function testCurrentStateChange():void {
			testPropertyChange(C, "currentState", "test");
		}
		
		[Test(async)]
		public function testCurrentStateNotChanged():void {
			testPropertyNotChanged(C, "currentState", "test");
		}
		
		[Test(async)]
		public function testTransitionsChange():void {
			testPropertyChange(C, "transitions", new Array());
		}
		
		[Test(async)]
		public function testTransitionsNotChanged():void {
			testPropertyNotChanged(C, "transitions", new Array());
		}
		
		[Test]
		public function testHasState():void {
			var instance:Object = new C();
			var statefulObject:IStateful = instance as IStateful;
			statefulObject.states = createTestStates();
			
			Assert.assertTrue(statefulObject.hasState("name1"));
			Assert.assertFalse(statefulObject.hasState("nonExistingStateName"));
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
	}
}