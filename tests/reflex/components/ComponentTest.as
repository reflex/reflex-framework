package reflex.components
{
	import flash.display.MovieClip;
	
	import reflex.display.StatefulTestBase;
	import reflex.tests.TestBase;
	
	public class ComponentTest extends StatefulTestBase
	{
		
		public function ComponentTest() {
			super();
			C = Component;
		}
		
		/*
		[Test(async)]
		public function testBehavoirsChange():void {
			testPropertyChange(Component, "behaviors", []);
		}
		*/
		
		[Test(async)]
		public function testSkinChange():void {
			testPropertyChange(C, "skin", new MovieClip());
		}
		
		[Test(async)]
		public function testSkinNotChanged():void {
			testPropertyNotChanged(C, "skin", new MovieClip());
		}
		
	}
}