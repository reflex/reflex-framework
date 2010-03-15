package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public interface ILayoutAlgorithm
	{
		function measure(target:DisplayObjectContainer):void;
		function layout(target:DisplayObjectContainer):void;
	}
}