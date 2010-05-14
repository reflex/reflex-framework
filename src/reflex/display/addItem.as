package reflex.display
{
	import flash.display.DisplayObject;
	
	import reflex.graphics.IDrawable;
	
	// the generic objects here are suspect, but I'm leaving them in for now.
	// Think DisplayObject3D from PaperVision, etc.
	public function addItem(container:Object, child:Object, template:Object = null):Object
	{
		var renderer:Object = getDataRenderer(child, template);
		container.addChild(renderer as DisplayObject);
		return renderer;
	}
	
}