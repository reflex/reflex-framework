package reflex.components
{
	import flexunit.framework.Assert;
	
	import reflex.tests.BaseClass;

	public class ListItemTest extends BaseClass
	{
		
		[Test(async)]
		public function testDataChange():void {
			testPropertyChange(ListItem, "data", "test");
		}
		
		[Test(async)]
		public function testDataNotChanged():void {
			testPropertyNotChanged(ListItem, "data", "test");
		}
		
		[Test]
		public function testNewInstance():void {
			var listItemDefinition:ListItem = new ListItem();
			// ListItemSkin caused test build to fail because it doesn't reference ReflexSkins.swc
			listItemDefinition.skin = {}; //new ListItemSkin();
			
			var newInstance:* = listItemDefinition.newInstance();
			
			Assert.assertNotNull(newInstance);
			Assert.assertTrue(newInstance is ListItem);
			
			var newInstanceOfListItem:ListItem = newInstance as ListItem;
			Assert.assertNotNull(newInstanceOfListItem);
		}
		
		[Test]
		public function testNewInstanceWithoutSettingSkin():void {
			var listItemDefinition:ListItem = new ListItem();
			
			try {
				var newInstance:* = listItemDefinition.newInstance();
				Assert.fail("Calling ListItemDefinition.newInstance() without first setting the skin should have thrown an error.");
			} catch (e:Error) {
				//This test should throw an error.  So, if we got here, this test passed.
			}
		}
	}
}