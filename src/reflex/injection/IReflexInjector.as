package reflex.injection
{
	import flash.display.Stage;
	import flash.events.IEventDispatcher;

	public interface IReflexInjector
	{
		
		function initialize(stage:Stage, app:IEventDispatcher):void;
		function injectInto(instance:Object):void;
		
	}
}