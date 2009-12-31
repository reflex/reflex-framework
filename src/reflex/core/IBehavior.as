package reflex.core
{
	import flash.display.InteractiveObject;

	public interface IBehavior
	{
		function get target():InteractiveObject;
		function set target(value:InteractiveObject):void;
		/*
		function get name():String;
		function set name(value:String):void;
		*/
	}
}