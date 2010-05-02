package reflex.components
{
	import reflex.behaviors.ButtonBehavior;
	import reflex.skins.ButtonSkin;
	
	public class Button extends Component
	{
		[Bindable]
		public var label:String;
		
		[Bindable]
		public var selected:Boolean;
		
		public function Button()
		{
			behaviors = new ButtonBehavior();
		}
		
		override protected function init():void
		{
			if (skin == null) {
				var buttonSkin:ButtonSkin = new ButtonSkin();
				skin = buttonSkin;
			}
			//behaviors = new ButtonBehavior();
		}
	}
}