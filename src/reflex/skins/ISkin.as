package reflex.skins
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	
	//import reflex.layout.ILayoutAlgorithm;
	
	/**
	 * @alpha
	 **/
	public interface ISkin
	{
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
		function getSkinPart(part:String):InteractiveObject;
	}
}