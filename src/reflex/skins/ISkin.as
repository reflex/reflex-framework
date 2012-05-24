package reflex.skins
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	//import reflex.layout.ILayoutAlgorithm;
	
	/**
	 * Implemented by objects which will provide the visual definition for a component's display.
	 * This interface is NOT required for items to be used as a skin in Reflex's skinning system.
	 * For instance animated MovieClips or other display classes may also act as a skin.
	 * 
	 * @alpha
	 */
	public interface ISkin
	{
		
		function get target():IEventDispatcher;
		function set target(value:IEventDispatcher):void;
		
		// not sure if getSkinPart should be required
		// maybe we could make it part of an extended interfaces?
		//function getSkinPart(part:String):InteractiveObject;
		
		function hasState( state:String ):Boolean;
		
	}
}