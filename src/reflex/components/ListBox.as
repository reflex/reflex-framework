package reflex.components
{
	import flight.binding.Bind;
	import flight.list.ArrayList;
	import flight.list.IList;
	import flight.position.IPosition;
	
	import reflex.skins.ListBoxSkin;

	public class ListBox extends Component
	{
		[Bindable]
		public var position:IPosition;
		
		[Bindable]
		public var template:Class;
		
		[Bindable]
		public var dataProvider:IList = new ArrayList();
		
		public function ListBox()
		{
		}
		
		override protected function init():void
		{
			var listBoxSkin:ListBoxSkin = new ListBoxSkin();
			skin = listBoxSkin;
			position = listBoxSkin.position;
			
			Bind.addBinding(listBoxSkin, "template", this, "template", true);
			Bind.addBinding(listBoxSkin, "dataProvider", this, "dataProvider", true);
		}
	}
}