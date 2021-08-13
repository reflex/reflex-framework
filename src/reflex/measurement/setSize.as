package reflex.measurement
{
	import reflex.framework.IMeasurable;
	
	public function setSize(child:Object, width:Number, height:Number):void
	{
		if(child is IMeasurable) { // || child is IDrawable
			child.setSize(width, height);
		} else if(child != null) {
			child.width = width;
			child.height = height;
		}
	}
	
}