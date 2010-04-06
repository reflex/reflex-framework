package
{
	import reflex.components.Application;
	import reflex.components.Button;
	import reflex.components.ListBox;
	import reflex.components.ScrollBar;
	
	import view.mxml_test;
	
	[SWF(widthPercent="100%", heightPercent="100%", frameRate="30")]
	public class reflex_dev extends Application
	{
		
		public function reflex_dev()
		{
			padding = 20;
			padding.horizontal = padding.vertical = 5;
			
			var button:Button = new Button();
			button.label = "hello world";		// TODO: make this work :)
			addChild(button);
			
			var listBox:ListBox;
			
			listBox = new ListBox();
			listBox.dock = "top";
			addChild(listBox);
			
//			listBox.padding = 15;
//			var btn:Button = new Button();
//			btn.dock = "right";
//			listBox.children.addItem(btn);
			
			listBox = new ListBox();
			listBox.dock = "top";
			addChild(listBox);
			
			addChild(new ScrollBar());
			
		}
		
	}
}

