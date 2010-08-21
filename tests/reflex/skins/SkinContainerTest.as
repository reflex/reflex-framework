package reflex.skins
{
	import reflex.display.ContainerTestBase;
	import reflex.display.ReflexDataTemplate;
	
	public class SkinContainerTest extends ContainerTestBase
	{
		public function SkinContainerTest()
		{
			super();
			C = Skin;
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
		
		[Test(async)]
		public function testTemplateChange():void {
			testPropertyChange(C, "template", new ReflexDataTemplate());
		}
		
		[Test(async)]
		public function testTemplateNotChanged():void {
			testPropertyChange(C, "template", new ReflexDataTemplate());
		}
		
	}
}