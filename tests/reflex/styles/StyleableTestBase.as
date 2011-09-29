package reflex.styles
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	import reflex.tests.BaseClass;

	public class StyleableTestBase extends BaseClass
	{
		
		public var C:Class;
		
		[Test(order=-1)]
		public function testIStyleable():void {
			var instance:Object = new C();
			Assert.assertTrue(instance is IStyleable);
			Assert.assertTrue(instance is IEventDispatcher);
		}
		
		[Test(async)]
		public function testIdChange():void {
			testPropertyChange(C, "id", "test");
		}
		
		[Test(async)]
		public function testIdNotChanged():void {
			testPropertyNotChanged(C, "id", "test");
		}
		
		[Test(async)]
		public function testStyleNameChange():void {
			testPropertyChange(C, "styleName", "test");
		}
		
		[Test(async)]
		public function testStyleNameNotChanged():void {
			testPropertyChange(C, "styleName", "test");
		}
		
		[Test]
		public function testGetStyle():void {
			var instance:IStyleable = new C();
			instance.setStyle("testStyle", "test");
			var v:Object = instance.getStyle("testStyle");
			Assert.assertEquals("test", v);
		}
		
		[Test]
		public function testSetStyle():void {
			var instance:IStyleable = new C();
			instance.setStyle("testStyle", "test");
			var v:Object = instance.getStyle("testStyle");
			Assert.assertEquals("test", v);
		}
		
	}
}