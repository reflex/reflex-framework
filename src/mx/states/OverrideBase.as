package mx.states
{
	
	import flash.events.EventDispatcher;
	
	public class OverrideBase extends EventDispatcher //implements IOverride
	{
		
		public function initialize():void {
			
		}
		
		public function apply(parent:Object):void {
			
		}
		
		public function remove(parent:Object):void {
			
		}
		
		/**
		 * @private
		 * @param parent The document level context for this override.
		 * @param target The component level context for this override.
		 */
		protected function getOverrideContext(target:Object, parent:Object):Object
		{
			if (target == null)
				return parent;
			
			if (target is String)
				return parent[target];
			
			return target;
		}
		
		
		public function initializeFromObject(properties:Object):Object {
			for (var p:String in properties)
			{
				this[p] = properties[p];
			}
			return Object(this);
		}
		
	}
}