package reflex.text
{
	
	import org.flexunit.async.Async;
	import reflex.tests.TestBase;
	
	[Ignore("incomplete")]
	public class LabelTest extends TestBase
	{
		
		// validation doesn't occur off the DisplayList
		// we'll need to fix Invalidation first
		
		[Test(async)] // text changes should trigger measurement
		public function testMeasurementInvalidation():void {
			var label:Label = new Label("x");
			var listener:Function = Async.asyncHandler(this, changeHandler, 500, "widthChange", timeoutHandler);
			label.addEventListener("widthChange", listener, false, 0, false);
			label.text = "test";
		}
		
		
	}
}