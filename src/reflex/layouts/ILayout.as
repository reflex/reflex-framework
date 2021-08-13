package reflex.layouts
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * This interface is used to Integrate custom layouts into the Reflex layout and measurement system.
	 * You must implement this interface when creating a custom layout.
	 * 
	 * @alpha
	 */
	public interface ILayout
	{
		
		function get target():IEventDispatcher;
		function set target(value:IEventDispatcher):void;
		
		function measure(content:Array):Point;
		function update(content:Array, tokens:Array, rectangle:Rectangle):Array;
		
	}
}