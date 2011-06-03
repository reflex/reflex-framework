package reflex.behaviors {
	import flexunit.framework.Assert;
	
	import reflex.tests.BaseClass;
	
	public class BehaviorTest extends BaseClass {
		
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