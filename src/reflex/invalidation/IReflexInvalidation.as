package reflex.invalidation
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	public interface IReflexInvalidation
	{
		
		
		// DisplayObject?
		function invalidate(instance:IEventDispatcher, phase:String):Boolean;
		function validate(instance:IEventDispatcher=null, phase:String=null):void;
		function add(instance:IEventDispatcher):void;
	}
}