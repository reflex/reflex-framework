package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public interface ILayout
	{
		function layout(target:DisplayObjectContainer):void;
		function measure(target:DisplayObjectContainer):void;
	}
}