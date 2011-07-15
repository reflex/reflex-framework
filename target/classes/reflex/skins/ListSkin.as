package reflex.skins
{
	import reflex.binding.Bind;
	import reflex.collections.SimpleCollection;
	import reflex.containers.Container;
	import reflex.containers.Group;
	import reflex.invalidation.Invalidation;
	import reflex.layouts.BasicLayout;
	import reflex.layouts.VerticalLayout;
	import reflex.layouts.XYLayout;
	
	
	public class ListSkin extends Skin
	{
		
		[Bindable]
		public var container:Container;
		
		public function ListSkin()
		{
			super();
			layout = new BasicLayout();
			container = new Container();
			container.setStyle("left", 0);
			container.setStyle("right", 0);
			container.setStyle("top", 0);
			container.setStyle("bottom", 0);
			content = new SimpleCollection([container]);
		}
		
	}
}