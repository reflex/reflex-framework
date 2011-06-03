package reflex.data {
	import flexunit.framework.Assert;
	
	import mx.collections.IList;
	
	import reflex.tests.BaseClass;

	public class SelectionTest extends BaseClass {

		public function SelectionTest() {
		}
		
		[Test(async)]
		public function testSelectedItemChange():void {
			testPropertyChange(Selection, "selectedItem", new Object());
		}
		
		[Test(async)]
		public function testSelectedItemNotChanged():void {
			testPropertyNotChanged(Selection, "selectedItem", "testValue");
		}

		[Test]
		public function testGetSelectedItems():void {
			var selection:Selection = new Selection();

			selection.selectedItem = "testValue";

			var resultList:IList = selection.selectedItems;

			Assert.assertEquals(1, resultList.length);
			Assert.assertEquals("testValue", resultList.getItemAt(0));
		}
	}
}