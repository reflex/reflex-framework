package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public interface ILayout
	{
		function get target():DisplayObjectContainer;
		function set target(value:DisplayObjectContainer):void;
		
		
		
		// measure the min/max width/height of the children
		// measure the "natrual size" of the children (usually equal to the min size of the children)
		function measure():void;
		function layout():void;
	}
}