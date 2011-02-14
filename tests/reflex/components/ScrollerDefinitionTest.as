package reflex.components
{
	import flexunit.framework.Assert;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	import reflex.collections.SimpleCollection;
	import reflex.tests.TestBase;
	
	public class ScrollerDefinitionTest extends TestBase
	{
		public function ScrollerDefinitionTest() {
			super();
		}
		
		[Test(async)]
		public function testHorizontalPositionChange():void {
			testPropertyChange(ScrollerDefinition, "horizontalPosition", new MockPosition());
		}
		
		[Test(async)]
		public function testHorizontalPositionNotChanged():void {
			testPropertyNotChanged(ScrollerDefinition, "horizontalPosition", new MockPosition());
		}
		
		[Test(async)]
		public function testVerticalPositionChange():void {
			testPropertyChange(ScrollerDefinition, "verticalPosition", new MockPosition());
		}
		
		[Test(async)]
		public function testVerticalPositionNotChanged():void {
			testPropertyNotChanged(ScrollerDefinition, "verticalPosition", new MockPosition());
		}
		
		[Test]
		public function testSetContentWithString():void {
			var scrollerDefinition:ScrollerDefinition = new ScrollerDefinition();
			
			scrollerDefinition.content = "testString";
			Assert.assertTrue(scrollerDefinition.content is SimpleCollection);
			
			var simpleCollection:SimpleCollection = scrollerDefinition.content as SimpleCollection;
			Assert.assertEquals(1, simpleCollection.length);
			Assert.assertEquals("testString", simpleCollection.getItemAt(0));
		}
		
		[Test]
		public function testSetContentWithIList():void {
			var scrollerDefinition:ScrollerDefinition = new ScrollerDefinition();
			
			var ilist:IList = new ArrayList();
			ilist.addItem("testIList");
			
			scrollerDefinition.content = ilist;
			Assert.assertTrue(scrollerDefinition.content is IList);
			
			var resultingIList:IList = scrollerDefinition.content as IList;
			Assert.assertEquals(1, resultingIList.length);
			Assert.assertEquals("testIList", resultingIList.getItemAt(0));
		}
		
		[Test]
		public function testSetContentWithArray():void {
			var scrollerDefinition:ScrollerDefinition = new ScrollerDefinition();
			
			var array:Array = ["testArray"];
			
			scrollerDefinition.content = array;
			Assert.assertTrue(scrollerDefinition.content is SimpleCollection);
			
			var simpleCollection:SimpleCollection = scrollerDefinition.content as SimpleCollection;
			Assert.assertEquals(1, simpleCollection.length);

			var firstItemInSimpleCollection:Object = simpleCollection.getItemAt(0);
			Assert.assertTrue(firstItemInSimpleCollection is String);
			Assert.assertEquals("testArray", firstItemInSimpleCollection);
		}

		[Test(async)]
		public function testLayoutChange():void {
			testPropertyChange(ScrollerDefinition, "layout", new MockLayout());
		}
		
		[Test(async)]
		public function testLayoutNotChanged():void {
			testPropertyNotChanged(ScrollerDefinition, "layout", new MockLayout);
		}
	}
}