package reflex.invalidation
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class HardCodedInvalidation implements IReflexInvalidation
	{
		
		//Invalidation.registerPhase(LifeCycle.CREATE, 0, true);
		Invalidation.registerPhase(LifeCycle.INITIALIZE, Event, 400, false);
		Invalidation.registerPhase(LifeCycle.COMMIT, Event, 300, false);
		Invalidation.registerPhase(LifeCycle.MEASURE, Event, 200, true);
		Invalidation.registerPhase(LifeCycle.LAYOUT, Event, 100, false);
		
		
		public function invalidate(instance:IEventDispatcher, phase:String):void
		{
			Invalidation.invalidate(instance, phase);
		}
		
		public function validate(instance:IEventDispatcher):void {
			Invalidation.validateNow()//render();
		}
		
	}
}