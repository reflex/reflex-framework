package reflex.display
{
	import reflex.graphics.IDrawable;
	
	// the generic objects here are suspect, but I'm leaving them in for now.
	// Think DisplayObject3D from PaperVision, etc.
	public function addChild(container:Object, child:Object):Object
	{
		/*
		if (container is IContainer) {
			return IContainer(container).children.addItem(child);
		} else {
			*/
			if(child is IDrawable) {
				(child as IDrawable).target = container;
				return child;
			} else {
				return container.addChild(child);
			}
			/*
		}*/
	}
	
}