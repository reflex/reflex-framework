package reflex.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import reflex.behaviors.ListSelectionBehavior;
	import reflex.binding.Bind;
	import reflex.data.Selection;
	import reflex.layouts.VerticalLayout;
	import reflex.skins.ListSkin;

	public class List extends ListDefinition
	{
		
		public function List()
		{
			super();
			selection = new Selection();
			layout = new VerticalLayout();
			(layout as VerticalLayout).gap = 10;
			template = ListItem;
			skin = new ListSkin();
			Bind.addBinding(this, "skin.container.content", this, "dataProvider");
			Bind.addBinding(this, "skin.container.template", this, "template");
			Bind.addBinding(this, "skin.container.layout", this, "layout");
			behaviors.addItem(new ListSelectionBehavior(this));
		}
		
	}
}