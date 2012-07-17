package reflex.display
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import reflex.events.DataChangeEvent;
	
	public class PropertyDispatcher extends EventDispatcher
	{
		
		include "../framework/PropertyDispatcherImplementation.as";
		
		public function PropertyDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
		
	}
}