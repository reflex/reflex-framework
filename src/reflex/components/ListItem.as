package reflex.components
{
	import mx.core.IDataRenderer;
	
	import reflex.behaviors.ButtonBehavior;
	
	/**
	 * @alpha
	 */
	public class ListItem extends Component implements IDataRenderer
	{
		[Bindable]
		public var label:String;
		
		[Bindable]
		public var selected:Boolean;
		
		[Bindable]
		public var data:Object;
		
		public function ListItem()
		{
			behaviors = new ButtonBehavior();
			skin = new ButtonGraphic();
		}
	}
}