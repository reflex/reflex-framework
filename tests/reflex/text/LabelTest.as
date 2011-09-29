package reflex.text
{
	
	import org.flexunit.async.Async;
	import reflex.tests.BaseClass;
	
	public class LabelTest extends BaseClass
	{
		
		// validation doesn't occur off the DisplayList
		// we'll need to fix Invalidation first
		
		[Test(async)] [Ignore]// text changes should trigger measurement
		public function testMeasurementInvalidation():void {
			var label:Label = new Label("x");
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "widthChange", timeoutHandler);
			label.addEventListener("widthChange", listener, false, 0, false);
			label.text = "test";
		}
		
		
	}
}