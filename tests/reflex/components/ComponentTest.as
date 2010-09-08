package reflex.components
{
	import flash.display.MovieClip;
	
	import reflex.display.StatefulTestBase;
	import reflex.tests.TestBase;
	
	public class ComponentTest extends TestBase
	{
		
		public function ComponentTest() {
			super();
			//C = Component;
		}
		
		/*
		[Test(async)]
		public function testBehavoirsChange():void {
			testPropertyChange(Component, "behaviors", []);
		}
		*/
		
		[Test(async)]
		public function testSkinChange():void {
			testPropertyChange(Component, "skin", new MovieClip());
		}
		
		[Test(async)]
		public function testSkinNotChanged():void {
			testPropertyNotChanged(Component, "skin", new MovieClip());
		}
		
		
		[Test(async)]
		public function testCurrentStateChange():void {
			testPropertyChange(Component, "currentState", "test");
		}
		
		[Test(async)]
		public function testCurrentStateNotChanged():void {
			testPropertyNotChanged(Component, "currentState", "test");
		}
		
		
		[Test(async)]
		public function testEnabledChange():void {
			testPropertyChange(Component, "enabled", false);
		}
		
		[Test(async)]
		public function testEnabledNotChanged():void {
			testPropertyNotChanged(Component, "enabled", false);
		}
		
	}
}