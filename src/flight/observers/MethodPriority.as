package flight.observers
{
	
	/**
	 * A small pooled link-list object that allows methods to be sorted by the order
	 * in which they were added to the observing system.
	 */
	internal final class MethodPriority
	{
		public var target:Function;
		public var priority:uint;
		public var next:MethodPriority;
		
		private static var pool:MethodPriority;
		
		public static function get(target:Function, priority:uint):MethodPriority
		{
			var mp:MethodPriority;
			
			if (pool == null) {
				mp = new MethodPriority();
			} else {
				mp = pool;
				pool = mp.next;
			}
			
			mp.target = target;
			mp.priority = priority;
			
			return mp;
		}
		
		public static function put(mp:MethodPriority):void
		{
			mp.target = null;
			mp.next = pool;
			pool = mp;
		}
		
		public static function sort(mpA:MethodPriority, mpB:MethodPriority):int
		{
			return mpA.priority - mpB.priority;
		}
		
		public static function map(item:MethodPriority, index:int, array:Array):Function
		{
			return item.target;
		}
	}
}