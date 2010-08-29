package reflex.display
{
	import org.flexunit.Assert;
	
	import reflex.styles.StyleableTestBase;
	
	public class StyleableSpriteTest extends StyleableTestBase
	{
		
		public function StyleableSpriteTest()
		{
			super();
			C = StyleableSprite;
		}
		
		[Test]
		public function testStyleString():void {
			var instance:StyleableSprite = new C();
			instance.style = "testStyle: test;"; // more complex parsing needed later
			var v:Object = instance.getStyle("testStyle");
			Assert.assertEquals("test", v);
		}
		
	}
}