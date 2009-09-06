package reflex.controls
{
	import reflex.core.Component;
	
	[DefaultSetting(skin="reflex.skins.ButtonSkin")]
	[DefaultSetting(behavior="reflex.behaviors.ButtonBehavior")]
	public class Button extends Component implements IEnableable, ISelectable, IStateful
	{
		
		[Bindable] public var label:String;
		
		[Bindable] override public var enabled:Boolean;
		
		[Bindable] public var selectable:Boolean;
		[Bindable] public var selected:Boolean;
		
		[Bindable] public var state:String;
	}
}