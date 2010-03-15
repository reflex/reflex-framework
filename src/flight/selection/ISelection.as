package flight.selection
{
	import flight.list.IList;
	
	public interface ISelection
	{
		function get item():Object;
		function set item(value:Object):void;
		
		function get multiselect():Boolean;
		function set multiselect(value:Boolean):void;
		
		function get items():IList;
		
		function select(items:*):void;
		
	}
}
