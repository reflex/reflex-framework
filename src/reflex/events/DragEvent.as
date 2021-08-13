package reflex.events
{
	import flash.events.Event;
	
	public class DragEvent extends Event
	{
		
		static public const DRAG_ENTER:String = "dragEnter";
		static public const DRAG_EXIT:String = "dragExit";
		static public const DRAG_DROP:String = "dragDrop";
		
		public var item:*;
		public var initiator:Object;
		
		public function DragEvent(type:String, initiator:Object, item:*)
		{
			super(type, false, false);
			this.initiator = initiator;
			this.item = item;
		}
		
	}
}