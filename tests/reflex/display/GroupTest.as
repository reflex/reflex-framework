package reflex.display
{
	import reflex.containers.Container;
	
	public class GroupTest extends ContainerTestBase
	{
		
		public function GroupTest() {
			super();
			C = Container;
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