package reflex.components
{
	
	import mx.collections.IList;
	
	import reflex.data.IPosition;
	import reflex.events.PropertyEvent;
	import reflex.layouts.ILayout;
	import reflex.layouts.VerticalLayout;
	import reflex.skins.ListSkin;
	
	/**
	 * @alpha
	 */
	public class List extends Component
	{
		
		private var _layout:ILayout;
		private var _dataProvider:IList;
		private var _template:Object;
		private var _position:IPosition;
		
		[Bindable(event="layoutChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void {
			if(_layout == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "layout", _layout, _layout = value);
		}
		
		[Bindable(event="dataProviderChange")]
		public function get dataProvider():IList { return _dataProvider; }
		public function set dataProvider(value:IList):void {
			if(_dataProvider ==  value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "dataProvider", _dataProvider, _dataProvider = value);
		}
		
		[Bindable(event="templateChange")]
		public function get template():Object { return _template; }
		public function set template(value:Object):void {
			if(_template == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "template", _template, _template = value);
		}
		
		[Bindable(event="positionChange")]
		public function get position():IPosition { return _position; }
		public function set position(value:IPosition):void {
			if(_position == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "position", _position, _position = value);
		}
		
		public function List()
		{
			if(skin == null) {
				skin = new ListSkin();
			}
			if(layout == null) {
				layout = new VerticalLayout();
			}
			if(template == null) {
				template = Button;
			}
		}
		
	}
}