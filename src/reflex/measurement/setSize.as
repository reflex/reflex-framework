package reflex.measurement
{
	import flash.display.DisplayObject;
	
	import reflex.display.MeasuredDisplayObject;
	import reflex.graphics.Rect;

	public function setSize(child:Object, width:Number, height:Number):void
	{
		// update to interface later of course
		if(child is IMeasurable || child is Rect) {
			child.setSize(width, height);
		} else if(child is DisplayObject) {
			child.width = width;
			child.height = height;
		}
	}
	
}