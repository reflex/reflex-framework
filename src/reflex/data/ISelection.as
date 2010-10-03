package reflex.data
{
	import mx.collections.IList;

	public interface ISelection
	{
		
		function get selectedItem():Object;
		function set selectedItem(value:Object):void;
		
		function get selectedItems():IList;
		//function set selectedItems(value:IList):void;
		
	}
}