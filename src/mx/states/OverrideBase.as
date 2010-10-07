package mx.states
{
	
	import flash.events.EventDispatcher;
	
	public class OverrideBase extends EventDispatcher //implements IOverride
	{
		
		public function initializeFromObject(properties:Object):Object {
			for (var p:String in properties)
			{
				this[p] = properties[p];
			}
			return Object(this);
		}
		
	}
}