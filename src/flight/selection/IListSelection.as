package flight.selection
{
	import flight.list.IList;
	
	public interface IListSelection extends ISelection
	{
		function get index():int;
		function set index(value:int):void;
		
		function get indices():IList;
	}
}
