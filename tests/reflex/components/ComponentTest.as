package reflex.components
{
	import flash.display.MovieClip;
	
	import reflex.tests.TestBase;
	
	public class ComponentTest extends TestBase
	{
		
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
		
	}
}