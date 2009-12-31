package reflex.controls
{
	import reflex.core.Component;
	
	// TODO: refactor DefaultSetting refelction in Component class
	[DefaultSetting(skin="reflex.skins.ButtonSkin")]
	[DefaultSetting(behaviors="reflex.behaviors.ButtonStateBehavior, reflex.behaviors.SelectableBehavior")]
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