package reflex.animation
{
	import flash.display.DisplayObject;
	
	import reflex.animation.AnimationToken;

	public interface IAnimator
	{
		
		function createAnimationToken(renderer:Object):AnimationToken;
		
		/**
		 * attaches this animator to a given container
		 */
		//function attach(container:Object):void;
		//function detach(container:Object):void;
		
		
		/**
		 * Called before a series of addItem, moveItem, or removeItem calls.
		 */
		function begin():void;
		
		// we might break these up into seperate interfaces later
		//function addItem(item:Object):void;
		function moveItem(item:Object, token:AnimationToken, type:String):void;
		//function adjustItem(item:Object, token:AnimationToken):void; // for scrolling, drag reactions etc.
		//function removeItem(item:Object, callback:Function):void;
		
		/**
		 * Called after a series of addItem, moveItem, or removeItem calls.
		 */
		function end():void;

	}
}