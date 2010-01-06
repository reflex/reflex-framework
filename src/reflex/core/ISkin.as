package reflex.core
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;

	public interface ISkin
	{
		function get target():Sprite;				// but I prefer ISkinnable targets, they're my favorite
		function set target(value:Sprite):void;		// cause then I'll use data, children, layout, state, etc
		
		function get data():Object;
		function set data(value:Object):void;
		
//		function get owner():ISkinnable;
//		function set owner(value:ISkinnable):void;
		
		function get state():String;
		function set state(value:String):void;
		
		function getSkinPart(part:String):InteractiveObject;
	}
}