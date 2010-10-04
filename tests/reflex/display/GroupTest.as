package reflex.display
{
	import reflex.containers.Group;
	
	public class GroupTest extends ContainerTestBase
	{
		
		public function GroupTest() {
			super();
			C = Group;
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