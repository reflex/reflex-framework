package reflex.display
{
	import flight.list.IList;
	
	import reflex.layout.ILayoutAlgorithm;

	public interface IContainer
	{
		function get children():IList;
		
		function get layout():ILayoutAlgorithm;
		function set layout(value:ILayoutAlgorithm):void;
	}
}