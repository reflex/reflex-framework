package reflex.core
{
	import flash.events.IEventDispatcher;

	public interface ISkin extends IEventDispatcher
	{
		function get owner():IComponent;
		function set owner(value:IComponent):void;
		
		function draw():void;
	}
}