package reflex.templating
{
	import flash.display.DisplayObject;
	
	import reflex.containers.Container;
	
	// the generic objects here are suspect, but I'm leaving them in for now.
	// Think DisplayObject3D from PaperVision, etc.
	public function addItemAt(container:Object, child:Object, index:int = 0, template:Object = null):Object
	{
		var renderer:Object = getDataRenderer(container, child, template);
		if (renderer is DisplayObject) {
			//container.addChildAt(renderer as DisplayObject, (index == -1) ? container.numChildren : index);
			
			// why did container have 0 children here when content was 3 and index was 2?
			container.addChildAt(renderer as DisplayObject, (index == -1) ? container.numChildren : Math.min(index, container.numChildren));
		}
		return renderer;
	}
	
}