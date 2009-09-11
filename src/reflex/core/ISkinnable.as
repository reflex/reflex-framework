package reflex.core
{
	import flash.events.IEventDispatcher;

	public interface ISkinnable extends IEventDispatcher
	{
		
		function get skin():Object;
		function set skin(value:Object):void;
		
		/*
		function get state():String;
		function set state(value:String):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		*/
	}
}