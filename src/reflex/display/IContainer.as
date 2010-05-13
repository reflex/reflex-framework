package reflex.display
{
	import flight.list.IList;
	
	import reflex.layouts.ILayout;
	
	/**
	 * @alpha
	 */
	public interface IContainer
	{
		function get children():IList;
		
		function get layout():ILayout;
		function set layout(value:ILayout):void;
		
		//function setSize(width:Number, height:Number):void;
	}
}