package reflex.containers {
	import flexunit.framework.Assert;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import reflex.collections.SimpleCollection;
	import reflex.components.MockLayout;
	import reflex.tests.TestBase;
	
	public class ContainerTestBase extends TestBase {

		public var C:Class;

		public function ContainerTestBase() {
			super();
		}
		
		[Test]
		public function testSetContentWithString():void {
			var instance:IContainer = new C();
			
			instance.content = "testString";
			Assert.assertTrue(instance.content is SimpleCollection);
			
			var simpleCollection:SimpleCollection = instance.content as SimpleCollection;
			Assert.assertEquals(1, simpleCollection.length);
			Assert.assertEquals("testString", simpleCollection.getItemAt(0));
		}
		
		[Test]
		public function testSetContentWithIList():void {
			var instance:IContainer = new C();
			
			var ilist:IList = new ArrayList();
			ilist.addItem("testIList");
			
			instance.content = ilist;
			Assert.assertTrue(instance.content is IList);
			
			var resultingIList:IList = instance.content as IList;
			Assert.assertEquals(1, resultingIList.length);
			Assert.assertEquals("testIList", resultingIList.getItemAt(0));
		}
		
		[Test]
		public function testSetContentWithArray():void {
			var instance:IContainer = new C();
			
			var array:Array = ["testArray"];
			
			instance.content = array;
			Assert.assertTrue(instance.content is SimpleCollection);
			
			var simpleCollection:SimpleCollection = instance.content as SimpleCollection;
			Assert.assertEquals(1, simpleCollection.length);
			
			var firstItemInSimpleCollection:Object = simpleCollection.getItemAt(0);
			Assert.assertTrue(firstItemInSimpleCollection is String);
			Assert.assertEquals("testArray", firstItemInSimpleCollection);
		}
		
		[Test]
		public function testSetContentWithVector():void {
			var instance:IContainer = new C();
			
			var vector:Vector.<String> = new Vector.<String>();
			vector.push("testVector");
			
			instance.content = vector;
			Assert.assertTrue(instance.content is SimpleCollection);
			
			var simpleCollection:SimpleCollection = instance.content as SimpleCollection;
			Assert.assertEquals(1, simpleCollection.length);
			
			var firstItemInSimpleCollection:Object = simpleCollection.getItemAt(0);
			Assert.assertTrue(firstItemInSimpleCollection is String);
			Assert.assertEquals("testVector", firstItemInSimpleCollection);
		}
		
		[Test(async)]
		public function testLayoutChange():void {
			testPropertyChange(C, "layout", new MockLayout());
		}
		
		[Test(async)]
		public function testLayoutNotChanged():void {
			testPropertyNotChanged(C, "layout", new MockLayout);
		}
	}
}