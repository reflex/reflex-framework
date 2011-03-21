package reflex.behaviors {
	import flexunit.framework.Assert;
	
	import reflex.tests.TestBase;
	
	public class BehaviorTest extends TestBase {
		
		public var C:Class = Behavior;

		[Test]
		public function testConstructor():void {
			var behavior:Behavior = new Behavior();
			Assert.assertNull(behavior.target);
		}

		[Test(async)]
		public function testTargetChange():void {
			testPropertyChange(C, "target", new MockEventDispatcher());
		}
		
		[Test(async)]
		public function testTargetNotChanged():void {
			testPropertyNotChanged(C, "target", new MockEventDispatcher());
		}
	}
}