package reflex.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	
	import reflex.graphics.IDrawable;
	
	// the generic objects here are suspect, but I'm leaving them in for now.
	// Think DisplayObject3D from PaperVision, etc.
	public function addItemAt(container:Object, child:Object, index:int = 0, template:Object = null):Object
	{
		var renderer:Object = getDataRenderer(child, template);
		container.addChildAt(renderer as DisplayObject, index);
		return renderer;
		/*
			if(child is DisplayObject) {
				return container.addChildAt(child as DisplayObject, index);
			} else if(child is IDrawable) {
				var shape:Shape = new Shape();
				(child as IDrawable).target = shape;
				container.addChildAt(shape, index);
				return shape;
			} else {
				//return container.addChildAt(child, index);
				var shape:Shape = new Shape();
				shape.graphics.beginFill(0x000000, 1);
				shape.graphics.drawRect(0, 0, 100, 100);
				shape.graphics.endFill();
				container.addChildAt(shape, index);
				return;
			}
		*/
	}
	
}