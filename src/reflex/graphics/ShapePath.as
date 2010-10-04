package reflex.graphics
{
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	import flash.display.IGraphicsFill;
	import flash.display.IGraphicsStroke;
	
	//import reflex.display.ShapeDisplay;
	//import reflex.graphics.paint.IFill;
	//import reflex.graphics.paint.IStroke;

	public class ShapePath //extends ShapeDisplay
	{
		//public var stroke:IStroke;
		//public var fill:IFill;
		
		protected var graphicsData:Vector.<IGraphicsData>;
		protected var graphicsPath:GraphicsPath;
		
		public function ShapePath()
		{
		}
		
		public function draw():void
		{
			//graphics.clear();
			//graphics.drawGraphicsData(graphicsData);
		}
		
	}
}