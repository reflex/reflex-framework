package reflex.layouts
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flexunit.Assert;
	
	import reflex.display.BindableSprite;

	
	public class HorizontalLayoutTest extends EventDispatcher
	{
		
		[Test]
		public function testMeasurement():void {
			var child1:BindableSprite = new BindableSprite();
			var child2:BindableSprite = new BindableSprite();
			
			child1.width = 20;
			child1.height = 20;
			
			child2.width = 20;
			child2.height = 20;
			
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 10;
			var point:Point = layout.measure([child1, child2]);
			Assert.assertEquals(60, point.x);
			Assert.assertEquals(20, point.y);
		}
		
		[Test]
		public function testLayout():void {
			var child1:BindableSprite = new BindableSprite();
			var child2:BindableSprite = new BindableSprite();
			
			child1.width = 20;
			child1.height = 20;
			
			child2.width = 20;
			child2.height = 20;
			
			var rectangle:Rectangle = new Rectangle(0, 0, 100, 100);
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.gap = 10;
			layout.update([child1, child2], rectangle);
			Assert.assertEquals(5, child1.x);
			Assert.assertEquals(35, child2.x);
		}
		
	}
}