package reflex.components
{
	
	import mx.collections.IList;
	
	import reflex.binding.DataChange;
	import reflex.data.IPosition;
	import reflex.data.IRange;
	import reflex.data.ISelection;
	import reflex.layouts.ILayout;
	import reflex.layouts.VerticalLayout;
	
	/**
	 * @alpha
	 */
	public class ListDefinition extends Component
	{
		
		private var _layout:ILayout;
		private var _dataProvider:IList;
		private var _template:Object;
		private var _position:IPosition;
		private var _selection:ISelection
		
		[Bindable(event="layoutChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			DataChange.change(this, "layout", _layout, _layout = value);
		}
		
		[Bindable(event="dataProviderChange")]
		public function get dataProvider():IList { return _dataProvider; }
		public function set dataProvider(value:IList):void {
			DataChange.change(this, "dataProvider", _dataProvider, _dataProvider = value);
		}
		
		[Bindable(event="templateChange")]
		public function get template():Object { return _template; }
		public function set template(value:Object):void {
			DataChange.change(this, "template", _template, _template = value);
		}
		
		[Bindable(event="selectionChange")]
		public function get selection():ISelection { return _selection; }
		public function set selection(value:ISelection):void {
			DataChange.change(this, "selection", _selection, _selection = value);
		}
		
		[Bindable(event="positionChange")]
		public function get position():IPosition { return _position; }
		public function set position(value:IPosition):void {
			DataChange.change(this, "position", _position, _position = value);
		}
		
	}
}