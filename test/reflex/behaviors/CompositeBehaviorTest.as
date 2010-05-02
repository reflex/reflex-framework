package reflex.behaviors
{
	import flash.events.EventDispatcher;
	
	import org.flexunit.Assert;
	
	import reflex.behaviors.CompositeBehavior;
	
	public class CompositeBehaviorTest extends EventDispatcher
	{
		
		private var behaviors:CompositeBehavior;
		
		[Before]
		public function setup():void {
			behaviors = new CompositeBehavior();
		}
		
		[After]
		public function destroy():void {
			behaviors = null;
		}
		
		[Test]
		public function testConstructor():void {
			Assert.assertNull(behaviors.target);
			behaviors = new CompositeBehavior(this);
			Assert.assertEquals(this, behaviors.target);
		}
		
		[Test]
		public function testTarget():void {
			Assert.assertNull(behaviors.target);
			behaviors.target = this;
			Assert.assertEquals(this, behaviors.target);
		}
		
		// Array Proxy Tests
		
		
		
		// Looping Tests
		
		[Test]
		public function testForLoop():void {
			var items:Array = [new MockBehavior(), new MockBehavior(), new MockBehavior()];
			behaviors.push(items[0], items[1], items[2]);
			for(var i:int = 0; i < behaviors.length; i++) {
				Assert.assertEquals(items[i], behaviors[i])
			}
		}
		
		[Test]
		public function testForEachLoop():void {
			var items:Array = [new MockBehavior(), new MockBehavior(), new MockBehavior()];
			
			var index:int = 0;
			behaviors.push(items[0], items[1], items[2]);
			for each(var behavior:Object in behaviors) {
				Assert.assertEquals(items[index], behavior);
				index++;
			}
		}
		
		[Test]
		public function testForInLoop():void {
			var items:Array = [new MockBehavior(), new MockBehavior(), new MockBehavior()];
			
			var index:int = 0;
			behaviors.push(items[0], items[1], items[2]);
			for(var key:String in behaviors) {
				Assert.assertEquals(items[index], behaviors[key]);
				index++;
			}
		}
		
	}
}