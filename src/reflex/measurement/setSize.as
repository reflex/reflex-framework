package reflex.measurement
{
	import reflex.display.ReflexDisplay;
	import reflex.graphics.Rect;

	public function setSize(child:Object, width:Number, height:Number):void
	{
		// update to interface later of course
		if(child is ReflexDisplay || child is Rect) {
			child.setSize(width, height);
		} else {
			child.width = width;
			child.height = height;
		}
	}
	
}