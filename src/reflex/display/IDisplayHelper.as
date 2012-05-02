package reflex.display
{
	import flash.display.Graphics;

	public interface IDisplayHelper
	{
		
		//function getDisplayItem():Object;
		
		function getGraphics(instance:Object):Graphics;
		
		function getNumChildren(instance:Object):int;
		
		function contains(instance:Object, child:Object):Boolean;
		function addChild(instance:Object, child:Object):Object;
		function addChildAt(instance:Object, child:Object, index:int):Object;
		function removeChild(instance:Object, child:Object):Object;
		function removeChildAt(instance:Object, index:int):Object;
		function removeChildren(instance:Object):void;
		
	}
}