package reflex.containers
{
	import reflex.layouts.HorizontalLayout;
	
	[Style(name="gap", format="Length")]
	[Style(name="verticalAlign", format="String", enumeration="top,middle,bottom")]
	public class HGroup extends Group
	{
		
		public function HGroup()
		{
			super();
			layout = new HorizontalLayout();
		}
		
	}
}