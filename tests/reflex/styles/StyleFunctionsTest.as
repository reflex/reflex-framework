package reflex.styles
{
	import org.flexunit.Assert;
	
	import reflex.display.Display;

	public class StyleFunctionsTest
	{
		
		[Test]
		public function testHasStyle():void {
			var instance:IStyleable = new Display();
			instance.setStyle("testStyle", "test");
			Assert.assertTrue(reflex.styles.hasStyle(instance, "testStyle"));
		}
		
		[Test]
		public function testResolveStyle():void {
			var instance:IStyleable = new Display();
			instance.setStyle("testStyle", "test");
			var v:* = reflex.styles.resolveStyle(instance, "testStyle");
			Assert.assertEquals("test", v);
		}
		
		[Test]
		public function testResolveStyleStandard():void {
			var instance:IStyleable = new Display();
			var v:* = reflex.styles.resolveStyle(instance, "testStyle", null, "test");
			Assert.assertEquals("test", v);
		}
		
	}
}