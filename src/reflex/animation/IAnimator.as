package reflex.animation
{
	import flash.display.DisplayObject;
	
	import reflex.animation.AnimationToken;

	public interface IAnimator
	{
		/**
		 * attaches this animator to a given container
		 */
		function attach(container:Object):void;
		function detach(container:Object):void;
		
		
		/**
		 * Called before a series of addItem, moveItem, or removeItem calls.
		 */
		function begin():void;
		
		// we might break these up into seperate interfaces later
		function addItem(item:DisplayObject):void;
		function moveItem(item:DisplayObject, token:AnimationToken):void;
		function adjustItem(item:DisplayObject, token:AnimationToken):void; // for scrolling, drag reactions etc.
		function removeItem(item:DisplayObject, callback:Function):void;
		
		/**
		 * Called after a series of addItem, moveItem, or removeItem calls.
		 */
		function end():void;

	}
}