package reflex.layouts
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flexunit.Assert;
	
	import reflex.display.Display;

	public class BasicLayoutTest extends EventDispatcher
	{
		
		// still playing around with how to best test these
		
		// measurement tests
		
		[Test]
		public function testMeasurementXY():void {
			var child1:Display = new Display();
			var child2:Display = new Display();
			
			child1.x = 5;
			child1.y = 5;
			child1.width = 20;
			child1.height = 20;
			
			child2.x = 10;
			child2.y = 10;
			child2.width = 20;
			child2.height = 20;
			
			var layout:BasicLayout = new BasicLayout();
			var point:Point = layout.measure([child1, child2]);
			Assert.assertEquals(30, point.x);
			Assert.assertEquals(30, point.y);
		}
		
		[Test]
		public function testMeasurementLeft():void {
			var layout:BasicLayout = new BasicLayout();
			var child:Display = new Display();
			
			child.width = 20;
			child.setStyle("left", 5);
			
			var point:Point = layout.measure([child]);
			Assert.assertEquals(25, point.x)
		}
		
		[Test]
		public function testMeasurementRight():void {
			var layout:BasicLayout = new BasicLayout();
			var child:Display = new Display();
			
			child.width = 20;
			child.setStyle("right", 5);
			
			var point:Point = layout.measure([child]);
			Assert.assertEquals(25, point.x)
		}
		
		[Test]
		public function testMeasurementLeftRight():void {
			var layout:BasicLayout = new BasicLayout();
			var child:Display = new Display();
			
			child.width = 20;
			child.setStyle("left", 5);
			child.setStyle("right", 5);
			
			var point:Point = layout.measure([child]);
			Assert.assertEquals(30, point.x)
		}
		
		[Test]
		public function testMeasurementTop():void {
			var layout:BasicLayout = new BasicLayout();
			var child:Display = new Display();
			
			child.height = 20;
			child.setStyle("top", 5);
			
			var point:Point = layout.measure([child]);
			Assert.assertEquals(25, point.y)
		}
		
		[Test]
		public function testMeasurementBottom():void {
			var layout:BasicLayout = new BasicLayout();
			var child:Display = new Display();
			
			child.height = 20;
			child.setStyle("bottom", 5);
			
			var point:Point = layout.measure([child]);
			Assert.assertEquals(25, point.y)
		}
		
		[Test]
		public function testMeasurementTopBottom():void {
			var layout:BasicLayout = new BasicLayout();
			var child:Display = new Display();
			
			child.height = 20;
			child.setStyle("top", 5);
			child.setStyle("bottom", 5);
			
			var point:Point = layout.measure([child]);
			Assert.assertEquals(30, point.y)
		}
		
		[Test]
		public function testMeasurementHorizontalCenter():void {
			var layout:BasicLayout = new BasicLayout();
			var child:Display = new Display();
			
			child.width = 20;
			child.setStyle("horizontalCenter", -5);
			
			var point:Point = layout.measure([child]);
			Assert.assertEquals(25, point.x)
		}
		
		[Test]
		public function testMeasurementVerticalCenter():void {
			var layout:BasicLayout = new BasicLayout();
			var child:Display = new Display();
			
			child.height = 20;
			child.setStyle("verticalCenter", -5);
			
			var point:Point = layout.measure([child]);
			Assert.assertEquals(25, point.y)
		}
		
		
		// layout tests
		
		[Test]
		public function testLeft():void {
			var child:Display = new Display();
			var layout:BasicLayout = new BasicLayout();
			layout.target = this;
			child.setStyle("left", 5);
			layout.update([child], new Rectangle(0, 0, 100, 100));
			Assert.assertEquals(5, child.x);
		}
		
		[Test]
		public function testRight():void {
			var child:Display = new Display();
			var layout:BasicLayout = new BasicLayout();
			layout.target = this;
			child.width = 20;
			child.setStyle("right", 5);
			layout.update([child], new Rectangle(0, 0, 100, 100));
			Assert.assertEquals(75, child.x);
		}
		
		[Test]
		public function testLeftRight():void {
			var child:Display = new Display();
			var layout:BasicLayout = new BasicLayout();
			layout.target = this;
			child.setStyle("left", 5);
			child.setStyle("right", 5);
			layout.update([child], new Rectangle(0, 0, 100, 100));
			Assert.assertEquals(5, child.x);
			Assert.assertEquals(90, child.width);
		}
		
		[Test]
		public function testTop():void {
			var child:Display = new Display();
			var layout:BasicLayout = new BasicLayout();
			layout.target = this;
			child.setStyle("top", 5);
			layout.update([child], new Rectangle(0, 0, 100, 100));
			Assert.assertEquals(5, child.y);
		}
		
		[Test]
		public function testBottom():void {
			var child:Display = new Display();
			var layout:BasicLayout = new BasicLayout();
			layout.target = this;
			child.height = 20;
			child.setStyle("bottom", 5);
			layout.update([child], new Rectangle(0, 0, 100, 100));
			Assert.assertEquals(75, child.y);
		}
		
		[Test]
		public function testTopBottom():void {
			var child:Display = new Display();
			var layout:BasicLayout = new BasicLayout();
			layout.target = this;
			child.setStyle("top", 5);
			child.setStyle("bottom", 5);
			layout.update([child], new Rectangle(0, 0, 100, 100));
			Assert.assertEquals(5, child.y);
			Assert.assertEquals(90, child.height);
		}
		
		[Test]
		public function testHorizontalCenter():void {
			var child1:Display = new Display();
			var child2:Display = new Display();
			var layout:BasicLayout = new BasicLayout();
			layout.target = this;
			child1.width = 20;
			child2.width = 20;
			child1.setStyle("horizontalCenter", 0);
			child2.setStyle("horizontalCenter", -5);
			layout.update([child1, child2], new Rectangle(0, 0, 100, 100));
			Assert.assertEquals(40, child1.x);
			Assert.assertEquals(35, child2.x);
		}
		
		[Test]
		public function testVerticalCenter():void {
			var child1:Display = new Display();
			var child2:Display = new Display();
			var layout:BasicLayout = new BasicLayout();
			layout.target = this;
			child1.height = 20;
			child2.height = 20;
			child1.setStyle("verticalCenter", 0);
			child2.setStyle("verticalCenter", -5);
			layout.update([child1, child2], new Rectangle(0, 0, 100, 100));
			Assert.assertEquals(40, child1.y);
			Assert.assertEquals(35, child2.y);
		}
		
	}
}