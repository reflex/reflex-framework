package reflex.components
{
	import mx.core.IDataRenderer;
	
	import reflex.binding.DataChange;

	public class ListItemDefinition extends Component implements IDataRenderer
	{
		
		private var _data:Object;
		
		[Bindable(event="layoutChange")]
		public function get data():Object { return _data; }
		public function set data(value:Object):void {
			DataChange.change(this, "data", _data, _data = value);
		}
		
	}
}