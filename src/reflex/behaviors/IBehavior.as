package reflex.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;
	
	/**
	 * @beta
	 */
	public interface IBehavior
	{
		function get target():IEventDispatcher;
		function set target(value:IEventDispatcher):void;
	}
}