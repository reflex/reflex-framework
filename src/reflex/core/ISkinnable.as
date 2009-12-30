package reflex.core
{
	import flash.events.IEventDispatcher;
	
	import flight.list.IList;
	
	import reflex.layout.ILayout;

	public interface ISkinnable extends IEventDispatcher
	{
		function get data():Object;
		function set data(value:Object):void;
		
		function get children():IList;
		function set children(value:IList):void;
		
		function get layout():ILayout;
		function set layout(value:ILayout):void;
		
		function get skin():ISkin;
		function set skin(value:ISkin):void;
		
		function get state():String;
		function set state(value:String):void;
	}
}