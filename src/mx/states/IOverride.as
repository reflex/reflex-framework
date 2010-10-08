package mx.states
{
	import flash.display.DisplayObject;

	public interface IOverride
	{
		
		function initialize():void;
		function apply(parent:Object):void;
		function remove(parent:Object):void;
		
	}
}