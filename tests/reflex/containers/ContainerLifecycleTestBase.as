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
	import reflex.tests.BaseClass;
	
	public class ContainerLifecycleTestBase extends BaseClass {

		public var C:Class;

		public function ContainerLifecycleTestBase() {
			super();
		}
		
		[Test]
		public function testSetContentWithString():void {
			var instance:IContainer = new C();
			var child:DisplayObject = new DisplayObject();
			instance.content = [child];
			
			var listener:Function = Async.asyncHandler(this, widthChangeHandler, 500, "measure", timeoutHandler);
			(instance as IEventDispatcher).addEventListener("measure", listener, false, 0, false);
			child.dispatchEvent(new Event("widthChange"));
			
			//Assert.assertTrue(instance.content is SimpleCollection);
			
		}
		
		private function widthChangeHandler(event:Event):void {
			
		}
		
		/*
		
		[Test(async)]
		public function testLayoutChange():void {
			testPropertyChange(C, "layout", new MockLayout());
		}
		
		[Test(async)]
		public function testLayoutNotChanged():void {
			testPropertyNotChanged(C, "layout", new MockLayout);
		}
		*/
	}
}