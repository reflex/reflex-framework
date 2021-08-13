package reflex.features
{
	import flash.events.IEventDispatcher;

	public interface IDragManager
	{
		
		function addTarget(instance:IEventDispatcher):void;
		function removeTarget(instance:IEventDispatcher):void;
		
		function isDragging():Boolean;
		
		function doDrag(initiator:Object, item:*):void;
		function acceptDragDrop(target:IEventDispatcher):void;
		//function showFeedback(feedback:String):void;
		//function getFeedback():String;
		function endDrag():void;
		
	}
}