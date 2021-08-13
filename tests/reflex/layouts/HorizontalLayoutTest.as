package reflex.layouts
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flexunit.Assert;
	
	import reflex.display.MeasurableItem;

	
	public class HorizontalLayoutTest extends EventDispatcher
	{
		
		[Test]
		// strait-forward measurement test
		public function testMeasurement():void {
			var child1:MeasurableItem = new MeasurableItem();
			var child2:MeasurableItem = new MeasurableItem();
			
			child1.width = 20;
			child1.height = 20;
			
			child2.width = 20;
			child2.height = 20;
			
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 10;
			var point:Point = layout.measure([child1, child2]);
			Assert.assertEquals(50, point.x);
			Assert.assertEquals(20, point.y);
		}
		
		// need to test percent-based measurement
		
		[Test]
		// strait-forward layout test
		public function testLayout():void {
			var child1:MeasurableItem = new MeasurableItem();
			var child2:MeasurableItem = new MeasurableItem();
			
			child1.width = 20;
			child1.height = 20;
			
			child2.width = 20;
			child2.height = 20;
			
			var rectangle:Rectangle = new Rectangle(0, 0, 100, 100);
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 10;
			layout.update([child1, child2], null, rectangle);
			Assert.assertEquals(0, child1.x);
			Assert.assertEquals(30, child2.x);
		}
		
		[Test]
		// percent-based layout test
		// width percentages are normalized but height percentages are not
		public function testPercentLayout():void {
			var child1:MeasurableItem = new MeasurableItem();
			child1.percentWidth = 100;
			child1.percentHeight = 100;
			
			var child2:MeasurableItem = new MeasurableItem();
			child2.percentWidth = 100;
			child2.percentHeight = 100;
			
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 5; // gap spacing is removed from available width
			layout.update([child1, child2], null, new Rectangle(0, 0, 100, 100));
			
			Assert.assertEquals(48, child1.width);
			Assert.assertEquals(100, child1.height);
			Assert.assertEquals(48, child2.width);
			Assert.assertEquals(100, child2.height);
		}
		
		[Test]
		// percent-based layout test
		// width percentages are based on available space but height percentages are not
		public function testAdjustedPercentLayout():void {
			//  adjust relative to 100% space
			var child1:MeasurableItem = new MeasurableItem();
			child1.width = 20;
			child1.height = 20;
			
			var child2:MeasurableItem =  new MeasurableItem();
			child2.percentWidth = 100;
			child2.percentHeight = 100;
			
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 5; // gap spacing is removed from available width
			layout.update([child1, child2], null, new Rectangle(0, 0, 100, 100));
			
			Assert.assertEquals(20, child1.width);
			Assert.assertEquals(20, child1.height);
			Assert.assertEquals(75, child2.width);
			Assert.assertEquals(100, child2.height);
		}
		
	}
}