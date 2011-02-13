package reflex.components
{
	import flexunit.framework.Assert;
	
	import reflex.tests.TestBase;

	public class ListItemTest extends TestBase
	{
		
		[Test(async)]
		public function testDataChange():void {
			testPropertyChange(ListItemDefinition, "data", "test");
		}
		
		[Test(async)]
		public function testDataNotChanged():void {
			testPropertyNotChanged(ListItemDefinition, "data", "test");
		}
		
		[Test]
		public function testNewInstance():void {
			var listItemDefinition:ListItemDefinition = new ListItemDefinition();
			listItemDefinition.skin = new ListItemSkin();
			
			var newInstance:* = listItemDefinition.newInstance();
			
			Assert.assertNotNull(newInstance);
			Assert.assertTrue(newInstance is ListItemDefinition);
			
			var newInstanceOfListItemDefinition:ListItemDefinition = newInstance as ListItemDefinition;
			Assert.assertNotNull(newInstanceOfListItemDefinition);
		}
		
		[Test]
		public function testNewInstanceWithoutSettingSkin():void {
			var listItemDefinition:ListItemDefinition = new ListItemDefinition();
			
			try {
				var newInstance:* = listItemDefinition.newInstance();
				Assert.fail("Calling ListItemDefinition.newInstance() without first setting the skin should have thrown an error.");
			} catch (e:Error) {
				//This test should throw an error.  So, if we got here, this test passed.
			}
		}
	}
}