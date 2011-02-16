package reflex.skins
{
	import reflex.display.StatefulContainerTestBase;
	
	public class SkinContainerTest extends StatefulContainerTestBase
	{
		public function SkinContainerTest()
		{
			super();
			C = Skin;
		}
		
		[Test(async)]
		public function testTemplateChange():void {
			testPropertyChange(C, "template", {});
		}
		
		[Test(async)]
		public function testTemplateNotChanged():void {
			testPropertyChange(C, "template", {});
		}
		
	}
}