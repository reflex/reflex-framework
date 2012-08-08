package reflex.skins
{
	import flash.events.Event;
	
	import reflex.binding.Bind;
	import reflex.collections.SimpleCollection;
	import reflex.components.Button;
	import reflex.components.Component;
	import reflex.containers.Container;
	import reflex.containers.Group;
	import reflex.containers.HGroup;
	import reflex.layouts.BasicLayout;
	import reflex.layouts.VerticalLayout;
	import reflex.layouts.XYLayout;
	
	
	public class ListSkin extends Skin
	{
		
		[Bindable]
		public var container:Container;
		
		override protected function initialize():void {
			super.initialize();
			container = this;
			/*
			layout = new BasicLayout();
			container = new Container();
			container.layout = new XYLayout();
			container.setStyle("left", 0);
			container.setStyle("right", 0);
			container.setStyle("top", 0);
			container.setStyle("bottom", 0);
			content = new SimpleCollection([container]);
			*/
		}
		
	}
}