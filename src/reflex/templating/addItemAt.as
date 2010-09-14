package reflex.templating
{
	import flash.display.DisplayObject;
	
	// the generic objects here are suspect, but I'm leaving them in for now.
	// Think DisplayObject3D from PaperVision, etc.
	public function addItemAt(container:Object, child:Object, index:int = 0, template:Object = null):Object
	{
		var renderer:Object = getDataRenderer(container, child, template);
		if (renderer is DisplayObject) {
			container.addChildAt(renderer as DisplayObject, index);
		}
		return renderer;
	}
	
}