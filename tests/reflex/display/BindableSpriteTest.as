package reflex.display
{
	import flash.events.Event;
	
	import reflex.events.PropertyEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	import reflex.measurement.Measurements;
	import reflex.tests.TestBase;
	
	public class BindableSpriteTest extends TestBase
	{
		
		[Test(async)]
		public function testXChange():void {
			testPropertyChange(BindableSprite, "x", 100);
		}
		
		[Test(async)]
		public function testXNotChanged():void {
			testPropertyNotChanged(BindableSprite, "x", 100);
		}
		
		[Test(async)]
		public function testYChange():void {
			testPropertyChange(BindableSprite, "y", 100);
		}
		
		[Test(async)]
		public function testYNotChanged():void {
			testPropertyNotChanged(BindableSprite, "y", 100);
		}
		
		[Test(async)]
		public function testWidthChange():void {
			testPropertyChange(BindableSprite, "width", 100);
		}
		
		[Test(async)]
		public function testWidthNotChanged():void {
			testPropertyNotChanged(BindableSprite, "width", 100);
		}
		
		[Test(async)]
		public function testHeightChange():void {
			testPropertyChange(BindableSprite, "height", 100);
		}
		
		[Test(async)]
		public function testHeightNotChanged():void {
			testPropertyNotChanged(BindableSprite, "height", 100);
		}
		
	}
}