package reflex.containers
{
	import reflex.layouts.VerticalLayout;
	
	[Style(name="gap", format="Length")]
	[Style(name="horizontalAlign", format="String", enumeration="left,center,right")]
	public class VGroup extends Container
	{
		
		public function VGroup()
		{
			super();
			layout = new VerticalLayout();
		}
		
	}
}