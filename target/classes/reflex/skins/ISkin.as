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
		
		// I don't like referencing concrete classes in interfaces
		// but will have to dig into better use cases later
		
		// I need to change invalidation to be comfortable off the display list and I can fix this
		function get target():Sprite;				// but I prefer ISkinnable targets, they're my favorite
		function set target(value:Sprite):void;		// cause then I'll use data, children, layout, state, etc
		/*
		function get layout():ILayoutAlgorithm;
		function set layout(value:ILayoutAlgorithm):void;
		*/
		/*
		function get data():Object;
		function set data(value:Object):void;
		*/
		/*
		function get state():String;
		function set state(value:String):void;
		*/
		
		// not sure if getSkinPart should be required
		// maybe we could make it part of an extended interfaces?
		//function getSkinPart(part:String):InteractiveObject;
		
		function hasState( state:String ):Boolean;
		
	}
}