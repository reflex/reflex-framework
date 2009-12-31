package reflex.controls
{
	import reflex.core.Component;
	
	[DefaultProperty("label")]
	public class Button extends Component implements ISelectable
	{
		[Bindable] public var label:String;
		[Bindable] public var selected:Boolean;
		
		public function Button()
		{
			// TEMP
//			skin = new ButtonSkin();
//			behaviors.buttonState = new ButtonStateBehavior();
//			behaviors.selectable = new SelectableBehavior();
		}
		
	}
}