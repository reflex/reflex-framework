package reflex.display
{
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import flight.list.ArrayList;
	import flight.list.IList;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	import reflex.display.IContainer;
	import reflex.layouts.XYLayout;
	import reflex.tests.TestBase;
	
	public class ContainerTestBase extends StatefulTestBase
	{
		
		//public var C:Class;
		
		[Test(order=-1)]
		public function testIContainer():void {
			var instance:Object = new C();
			Assert.assertTrue(instance is IContainer);
			Assert.assertTrue(instance is IEventDispatcher);
		}
		
		[Test(async)]
		public function testChildrenChange():void {
			testPropertyChange(C, "content", new ArrayList());
		}
		
		[Test(async)]
		public function testChildrenNotChanged():void {
			testPropertyNotChanged(C, "content", new ArrayList());
		}
		
		[Test(async)]
		public function testLayoutChange():void {
			testPropertyChange(C, "layout", new XYLayout());
		}
		
		[Test(async)]
		public function testLayoutNotChanged():void {
			testPropertyNotChanged(C, "layout", new XYLayout());
		}
		
		[Test]
		public function testChildrenArrayConversion():void {
			//  containers may be assigned vanilla Arrays in MXML and will be required to convert them to an IList
			var container:IContainer = new C();
			var test1:DisplayObject = new Sprite();
			var test2:DisplayObject = new Shape();
			var test3:DisplayObject = new Bitmap();
			container.content = [test1, test2, test3];
			var list:IList = container.content;
			Assert.assertNotNull(list);
			Assert.assertTrue(list is IList);
			Assert.assertEquals(test1, list.getItemAt(0));
			Assert.assertEquals(test2, list.getItemAt(1));
			Assert.assertEquals(test3, list.getItemAt(2));
		}
		
	}
}