package reflex.data
{
	import mx.collections.IList;

	public interface ISelection
	{
		
		[Bindable(event="selectedItemChange")]
		function get selectedItem():Object;
		function set selectedItem(value:Object):void;
		
		[Bindable(event="selectedItemsChange")]
		function get selectedItems():IList;
		//function set selectedItems(value:IList):void;
		
	}
}