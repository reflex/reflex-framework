package
{
	import reflex.components.Application;
	import reflex.components.Button;
	import reflex.components.ListBox;
	
	import view.mxml_test;
	
	[SWF(widthPercent="100%", heightPercent="100%", frameRate="12")]
	public class reflex_dev extends Application
	{
		
		public function reflex_dev()
		{
			padding = 20;
			padding.horizontal = padding.vertical = 5;
			
			var listBox:ListBox;
			var mxml:mxml_test;
			
			listBox = new ListBox();
			mxml = new mxml_test();
			listBox.skin = mxml;
			listBox.dock = "top";
			addChild(listBox);
			
//			listBox.padding = 15;
//			var btn:Button = new Button();
//			btn.dock = "right";
//			listBox.children.addItem(btn);
			
			listBox = new ListBox();
			mxml = new mxml_test();
			listBox.skin = mxml;
			listBox.dock = "top";
			addChild(listBox);
			
		}
		
	}
}

