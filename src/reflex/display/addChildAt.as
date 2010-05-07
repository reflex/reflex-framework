package reflex.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import reflex.graphics.IDrawable;
	
	// the generic objects here are suspect, but I'm leaving them in for now.
	// Think DisplayObject3D from PaperVision, etc.
	public function addChildAt(container:Object, child:Object, index:int):Object
	{
		/*
		if (container is IContainer) {
			return IContainer(container).children.addItemAt(child, index);
		} else {
			*/
			if(child is IDrawable) {
				(child as IDrawable).target = container;
				return child;
			} else {
				return container.addChildAt(child, index);
			}
			/*
			
		}*/
	}
	
}