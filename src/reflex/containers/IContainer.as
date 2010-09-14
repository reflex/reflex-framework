package reflex.containers
{
	import mx.collections.IList;
	
	import reflex.layouts.ILayout;
	
	/**
	 * Implemented by objects which can contain and layout children.
	 * 
	 * @alpha
	 */
	public interface IContainer
	{
		
		/**
		 * Holds the children to be measured and positioned by the container.
		 * Use children.addItem, children.removeItem, etc to add/remove items participating in measurement and layout.
		 * Note that you can still manipulate the DisplayList directly using the addChild, removeChildAt, etc. methods of DisplayObjectContainer,
		 * however children added manually will not be measured or positioned by the container.
		 */
		function get content():IList;
		
		/**
		 * The layout used to measure and position this container's children.
		 */
		function get layout():ILayout;
		function set layout(value:ILayout):void;
		
	}
}