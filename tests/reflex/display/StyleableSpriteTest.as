package reflex.display
{
	import reflex.styles.StyleableTestBase;
	
	public class StyleableSpriteTest extends StyleableTestBase
	{
		public function StyleableSpriteTest()
		{
			super();
			C = StyleableSprite;
		}
		
		[Test(async)]
		public function testStatesChange():void {
			testPropertyChange(C, "states", []);
		}
		
		[Test(async)]
		public function testStatesNotChanged():void {
			testPropertyNotChanged(C, "states", []);
		}
		
		[Test(async)]
		public function testCurrentStateChange():void {
			testPropertyChange(C, "currentState", "test");
		}
		
		[Test(async)]
		public function testCurrentStateNotChanged():void {
			testPropertyNotChanged(C, "currentState", "test");
		}
		
	}
}