package reflex.display
{
	import flash.events.Event;
	
	import flight.list.ArrayList;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	import reflex.layouts.XYLayout;

	public class ContainerTest extends ContainerTestBase
	{
		
		public function ContainerTest() {
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