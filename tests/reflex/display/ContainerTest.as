package reflex.display
{
	import flash.events.Event;
	
	import flight.list.ArrayList;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	import reflex.layouts.XYLayout;

	public class ContainerTest
	{
		
		[Test(async)]
		public function testChildrenChange():void {
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "childrenChange", timeoutHandler);
			var container:Container = new Container();
			container.addEventListener("childrenChange", listener, false, 0, false);
			container.children = new ArrayList();
		}
		
		[Test(async)]
		public function testLayoutChange():void {
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "layoutChange", timeoutHandler);
			var container:Container = new Container();
			container.addEventListener("layoutChange", listener, false, 0, false);
			container.layout = new XYLayout();
		}
		
		[Test(async)]
		public function testTemplateChange():void {
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "templateChange", timeoutHandler);
			var container:Container = new Container();
			container.addEventListener("templateChange", listener, false, 0, false);
			container.template = new ReflexDataTemplate();
		}
		
		private function changeHandler(event:Event, type:String):void {
			Assert.assertEquals(event.type, type);
		}
		
		private function timeoutHandler(type:String):void {
			Assert.fail(type + ": timed out.");
		}
		
	}
}