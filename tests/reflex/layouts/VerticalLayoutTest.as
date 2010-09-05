package reflex.layouts
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import org.flexunit.Assert;
	
	import reflex.display.BindableSprite;

	public class VerticalLayoutTest extends EventDispatcher
	{
		
		[Test]
		public function testMeasurement():void {
			var child1:BindableSprite = new BindableSprite();
			var child2:BindableSprite = new BindableSprite();
			
			child1.width = 20;
			child1.height = 20;
			
			child2.width = 20;
			child2.height = 20;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 10;
			var point:Point = layout.measure([child1, child2]);
			Assert.assertEquals(20, point.x);
			Assert.assertEquals(60, point.y);
		}
		
	}
}