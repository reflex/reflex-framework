package reflex.skins
{
	import reflex.components.Button;
	import reflex.components.TextInput;
	import reflex.layouts.HorizontalLayout;

	public class StepperSkin extends Skin
	{
		
		public var textField:TextInput;
		
		public var decrementButton:Button;
		public var incrementButton:Button;
		
		public function StepperSkin()
		{
			super();
			layout = new HorizontalLayout();
			textField = new TextInput("");
			textField.width = 100;
			textField.percentHeight = 100;
			
			decrementButton = new Button("-");
			decrementButton.width = 60;
			decrementButton.height = 60;
			incrementButton = new Button("+");
			incrementButton.width = 60;
			incrementButton.height = 60;
			content = [textField, decrementButton, incrementButton];
		}
	}
}