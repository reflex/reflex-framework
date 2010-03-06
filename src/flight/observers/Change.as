package flight.observers
{
	
	/**
	 * A small pooled link-list object that keeps state for a change that is being
	 * processed.
	 */
	internal final class Change
	{
		public var target:Object;
		public var property:String;
		public var oldValue:*;
		public var newValue:*;
		public var next:Change;
		
		private static var pool:Change;
		
		public static function get(target:Object, property:String, oldValue:*, newValue:*):Change
		{
			var change:Change;
			
			if (pool == null) {
				change = new Change();
			} else {
				change = pool;
				pool = change.next;
			}
			
			change.target = target;
			change.property = property;
			change.oldValue = oldValue;
			change.newValue = newValue;
			
			return change;
		}
		
		public static function put(change:Change):void
		{
			change.target = null;
			change.property = null;
			change.oldValue = null;
			change.newValue = null;
			change.next = pool;
			pool = change;
		}
	}
}