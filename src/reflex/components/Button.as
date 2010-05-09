package reflex.components
{
	import reflex.behaviors.ButtonBehavior;
	import reflex.skins.ButtonSkin;
	
	//[Event(type="click")]
	public class Button extends Component
	{
		[Bindable]
		public var label:String;
		
		[Bindable]
		public var selected:Boolean;
		
		public function Button()
		{
			behaviors = new ButtonBehavior();
			//skin = new ButtonSkin(new ButtonGraphic());
			skin = new ButtonGraphic();
		}
		
	}
}