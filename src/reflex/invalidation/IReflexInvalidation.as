package reflex.invalidation
{
	import flash.display.DisplayObject;

	public interface IReflexInvalidation
	{
		
		
		// DisplayObject?
		function invalidate(instance:DisplayObject, phase:String):void;
		
	}
}