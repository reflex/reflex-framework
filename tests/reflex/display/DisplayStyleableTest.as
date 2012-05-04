package reflex.display
{
	import org.flexunit.Assert;
	
	import reflex.styles.IStyleable;
	import reflex.styles.StyleableTestBase;
	
	public class DisplayStyleableTest extends StyleableTestBase
	{
		
		public function DisplayStyleableTest()
		{
			super();
			C = MeasurableItem;
		}
		
		[Test]
		public function testStyleString():void {
			var instance:MeasurableItem = new C();
			instance.style = "testStyle: test;"; // more complex parsing needed later
			var v:Object = instance.getStyle("testStyle");
			Assert.assertEquals("test", v);
		}
		
	}
}