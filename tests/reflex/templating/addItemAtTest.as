package reflex.templating
{
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import org.flexunit.Assert;

	public class addItemAtTest
	{
		
			// needs more tests
			
		[Test]
		public function testaddItemAtN1():void {
			var container:DisplayObjectContainer = new Sprite();
			container.addChild(new Sprite());
			container.addChild(new MovieClip());
			var child:Shape = new Shape();
			reflex.templating.addItemAt(container, child, -1);
			Assert.assertEquals(child, container.getChildAt(2));
		}
		
	}
}