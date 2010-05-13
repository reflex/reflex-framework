package reflex.layouts
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * @alpha
	 */
	public interface ILayout
	{
		
		function get target():IEventDispatcher;
		function set target(value:IEventDispatcher):void;
		
		function measure(children:Array):Point;
		function update(children:Array, rectangle:Rectangle):void;
	}
}