package reflex.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;

	public interface IBehavior
	{
		function get target():IEventDispatcher;
		function set target(value:IEventDispatcher):void;
	}
}