package reflex.display
{
	
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	
	import org.flexunit.Assert;
	
	import reflex.components.ListItemDefinition;
	import reflex.templating.IDataTemplate;
	import reflex.templating.getDataRenderer;

	public class DisplayFunctionsTest
	{
		
		[Test]
		public function testGetDataRendererForIDataTemplate():void {
			var template:IDataTemplate = new TestTemplate();
			var instance:Object = getDataRenderer(this, "test", template);
			Assert.assertTrue(instance is ListItemDefinition);
			Assert.assertEquals("test", instance.data);
		}
		
		[Test]
		public function testGetDataRendererForClass():void {
			var instance:Object = getDataRenderer(this, "test", ListItemDefinition);
			Assert.assertTrue(instance is ListItemDefinition);
			Assert.assertEquals("test", instance.data);
		}
		
		[Test]
		public function testGetDataRendererForIFactory():void {
			var factory:IFactory = new ClassFactory(ListItemDefinition);
			var instance:Object = getDataRenderer(this, "test", factory);
			Assert.assertTrue(instance is ListItemDefinition);
			Assert.assertEquals("test", instance.data);
		}
		
		[Test]
		public function testGetDataRendererForFunction():void {
			var instance:Object = getDataRenderer(this, "test", templateFunction);
			Assert.assertTrue(instance is ListItemDefinition);
			Assert.assertEquals("test", instance.data);
		}
		
		[Test]
		public function testGetDataRendererForComponentObject():void {
			var instance:Object = getDataRenderer(this, new ListItemDefinition(), null);
			Assert.assertTrue(instance is ListItemDefinition);
		}
		
		private function templateFunction(data:Object):Object {
			return new ListItemDefinition();
		}
		
	}
	
}
import reflex.components.Component;
import reflex.components.ListItemDefinition;
import reflex.templating.IDataTemplate;

class TestTemplate implements IDataTemplate
{
	
	public function createDisplayObject(data:*):Object {
		return new ListItemDefinition();
	}
	
}