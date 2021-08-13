package reflex.events
{
	import flash.events.Event;
	
	public class ContainerEvent extends Event
	{
		
		static public var ITEM_ADDED:String = "itemAdded";
		static public var ITEM_REMOVED:String = "itemRemoved";
		
		public var item:*;
		public var renderer:Object;
		
		public function ContainerEvent(type:String, item:*, renderer:Object)
		{
			this.item = item;
			this.renderer = renderer
			super(type, false, false);
		}
	}
}