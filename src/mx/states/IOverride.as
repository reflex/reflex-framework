package mx.states
{
	import flash.display.DisplayObject;

	public interface IOverride
	{
		
		function initialize():void;
		function apply(parent:DisplayObject):void;
		function remove(parent:DisplayObject):void;
		
	}
}