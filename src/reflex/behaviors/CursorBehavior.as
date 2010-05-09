package reflex.behaviors
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	
	import flight.binding.Bind;
	
	import reflex.cursors.Cursor;
	
	public class CursorBehavior extends Behavior
	{
		[Bindable]
		public var cursor:Object;
		
		public function CursorBehavior(target:IEventDispatcher=null)
		{
			super(target);
			Bind.addListener(this, cursorChange, this, "cursor");
			Bind.addListener(this, targetChange, this, "target");
		}
		
		protected function cursorChange(cursor:Object):void
		{
			if (target) {
				Cursor.useCursor(target, cursor);
			}
		}
		
		protected function targetChange(oldTarget:InteractiveObject, newTarget:InteractiveObject):void
		{
			if (oldTarget && cursor) Cursor.useCursor(oldTarget, null);
			if (newTarget && cursor) Cursor.useCursor(newTarget, cursor);
		}
	}
}