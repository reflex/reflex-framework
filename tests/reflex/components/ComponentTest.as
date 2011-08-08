package reflex.components
{
	import flash.display.MovieClip;
	
	import flexunit.framework.Assert;
	
	import mx.collections.IList;
	
	import org.flexunit.asserts.assertEquals;
	
	import reflex.behaviors.IBehavior;
	import reflex.behaviors.MockBehavior;
	import reflex.display.StatefulTestBase;
	import reflex.tests.BaseClass;
	
	public class ComponentTest extends BaseClass
	{
		
		public function ComponentTest() {
			super();
			//C = Component;
		}
		
		/*
		[Test(async)]
		public function testBehavoirsChange():void {
			testPropertyChange(Component, "behaviors", []);
		}
		*/
		
		[Test]
		public function testSetBehavoirsUsingArray():void {
			var proposedBehaviors:Array = [new MockBehavior(), new MockBehavior(), new MockBehavior()];
			
			var c:Component = new Component();
			
			c.behaviors = proposedBehaviors;
			var resultingBehaviors:IList = c.behaviors;
			
			Assert.assertEquals(proposedBehaviors.length, resultingBehaviors.length);
			
			var numberOfResultingBehaviors:int = resultingBehaviors.length;
			
			for(var i:int = 0; i < numberOfResultingBehaviors; i++) {
				var proposedBehavior:IBehavior = proposedBehaviors[i];
				var resultBehavior:IBehavior = resultingBehaviors.getItemAt(i) as IBehavior;
				Assert.assertEquals(proposedBehavior, resultBehavior);
			}
		}
		
		[Test]
		public function testSetBehavoirsUsingSingleBehavior():void {
			var proposedBehavior:IBehavior = new MockBehavior();
			
			var c:Component = new Component();
			
			c.behaviors = proposedBehavior;
			var resultingBehaviors:IList = c.behaviors;
			
			Assert.assertEquals(1, resultingBehaviors.length);
			Assert.assertEquals(proposedBehavior, resultingBehaviors.getItemAt(0));
		}

		[Test(async)]
		public function testSkinChange():void {
			testPropertyChange(Component, "skin", new MovieClip());
		}
		
		[Test(async)]
		public function testSkinNotChanged():void {
			testPropertyNotChanged(Component, "skin", new MovieClip());
		}
		
		
		[Test(async)]
		public function testCurrentStateChange():void {
			testPropertyChange(Component, "currentState", "test");
		}
		
		[Test(async)]
		public function testCurrentStateNotChanged():void {
			testPropertyNotChanged(Component, "currentState", "test");
		}
		
		
		[Test(async)]
		public function testEnabledChange():void {
			testPropertyChange(Component, "enabled", false);
		}
		
		[Test(async)]
		public function testEnabledNotChanged():void {
			testPropertyNotChanged(Component, "enabled", false);
		}
		
	}
}