package reflex.display
{
	
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	
	import org.flexunit.Assert;
	
	import reflex.components.ListItem;
	import reflex.templating.IDataTemplate;
	import reflex.templating.getDataRenderer;

	public class DisplayFunctionsTest
	{
		
		[Test]
		public function testGetDataRendererForIDataTemplate():void {
			var template:IDataTemplate = new TestTemplate();
			var instance:Object = getDataRenderer(this, "test", template);
			Assert.assertTrue(instance is ListItem);
			Assert.assertEquals("test", instance.data);
		}
		
		[Test]
		public function testGetDataRendererForClass():void {
			var instance:Object = getDataRenderer(this, "test", ListItem);
			Assert.assertTrue(instance is ListItem);
			Assert.assertEquals("test", instance.data);
		}
		
		[Test]
		public function testGetDataRendererForIFactory():void {
			var factory:IFactory = new ClassFactory(ListItem);
			var instance:Object = getDataRenderer(this, "test", factory);
			Assert.assertTrue(instance is ListItem);
			Assert.assertEquals("test", instance.data);
		}
		
		[Test]
		public function testGetDataRendererForFunction():void {
			var instance:Object = getDataRenderer(this, "test", templateFunction);
			Assert.assertTrue(instance is ListItem);
			Assert.assertEquals("test", instance.data);
		}
		
		[Test]
		public function testGetDataRendererForComponentObject():void {
			var instance:Object = getDataRenderer(this, new ListItem(), null);
			Assert.assertTrue(instance is ListItem);
		}
		
		private function templateFunction(data:Object):Object {
			return new ListItem();
		}
		
	}
	
}
import reflex.components.Component;
import reflex.components.ListItem;
import reflex.templating.IDataTemplate;

class TestTemplate implements IDataTemplate
{
	
	public function createDisplayObject(data:*):Object {
		return new ListItem();
	}
	
}