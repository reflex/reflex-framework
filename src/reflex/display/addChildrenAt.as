package reflex.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import reflex.graphics.IDrawable;
	
	// the generic objects here are suspect, but I'm leaving them in for now.
	// Think DisplayObject3D from PaperVision, etc.
	public function addChildrenAt(container:Object, children:Array, index:int):void
	{
		var length:int = children.length;
		for(var i:int = 0; i < length; i++) {
			var child:Object = children[i];
			addChildAt(container, child, index);
			
			// I think this is why Flex4 skins have a seperate graphics declaration.
			// we'll have to account for this better later.
			if(child is DisplayObject) {
				index++;
			}
		}
	}
	
}