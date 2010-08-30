package reflex.tests
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	public class TestBase extends EventDispatcher
	{
		
		// tests that the appropriate PropertyChange 
		protected function testPropertyChange(C:Class, property:String, value:*):Object {
			var instance:Object = new C();
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, property + "Change", timeoutHandler);
			(instance as IEventDispatcher).addEventListener(property + "Change", listener, false, 0, false);
			instance[property] = value;
			Assert.assertEquals(value, instance[property]);
			return instance;
		}
		
		protected function testPropertyNotChanged(C:Class, property:String, value:*):Object {
			var instance:Object = new C();
			instance[property] = value;
			Async.failOnEvent(this, instance as IEventDispatcher, property + "Change", 500, timeoutHandler);
			instance[property] = value;
			return instance;
		}
		
		protected function changeHandler(event:Event, type:String):void {
			Assert.assertEquals(event.type, type);
		}
		
		protected function timeoutHandler(type:String):void {
			Assert.fail(type + ": timed out.");
		}
		
	}
}