package reflex.containers {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import flexunit.framework.Assert;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import org.flexunit.async.Async;
	
	import reflex.collections.SimpleCollection;
	import reflex.components.MockLayout;
	import reflex.invalidation.LifeCycle;
	import reflex.tests.BaseClass;
	
	public class LifecycleTest extends BaseClass {

		public var C:Class;

		public function LifecycleTest() {
			super();
		}
		
		[Test]
		public function testInitialization():void {
			var instance:IEventDispatcher = new C();
			//instance.addEventListener(LifeCycle.CREATE, ;
			//Assert.assertTrue(instance.content is SimpleCollection);
			
		}
		
	}
}