package flight.events
{
	import flash.events.Event;

	public class ListEvent extends Event
	{
		public static const LIST_CHANGE:String = "listChange";
		
		private var _kind:String;
		private var _items:*;
		private var _location1:int;
		private var _location2:int;
		
		public function ListEvent(type:String, kind:String, items:* = null, location1:int = -1, location2:int = -1)
		{
			super(type);
			
			_kind = kind;
			_items = items;
			_location1 = location1;
			_location2 = location2;
		}
		
		public function get kind():String
		{
			return _kind;
		}
		
		public function get items():*
		{
			return _items;
		}
		
		public function get location1():int
		{
			return _location1;
		}
		
		public function get location2():int
		{
			return _location2;
		}
		
		override public function clone():Event
		{
			return new ListEvent(type, _kind, _items, _location1, _location2);
		}
	}
}