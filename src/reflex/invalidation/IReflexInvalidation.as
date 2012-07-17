package reflex.invalidation
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	public interface IReflexInvalidation
	{
		
		
		// DisplayObject?
		function invalidate(instance:IEventDispatcher, phase:String):void;
		function validate(instance:IEventDispatcher):void;
		
	}
}