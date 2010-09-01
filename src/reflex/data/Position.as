package reflex.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Position extends EventDispatcher implements IPosition
	{
		
		// todo: update to account for ISnappingPosition
		
		public function Position()
		{
			super();
		}
		
		public function get min():Number
		{
			return 0;
		}
		
		public function set min(value:Number):void
		{
		}
		
		public function get max():Number
		{
			return 0;
		}
		
		public function set max(value:Number):void
		{
		}
		
		public function get value():Number
		{
			return 0;
		}
		
		public function set value(value:Number):void
		{
		}
	}
}