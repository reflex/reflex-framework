package reflex.components
{
	
	import reflex.behaviors.ScrollerBehavior;
	import reflex.binding.Bind;
	import reflex.collections.SimpleCollection;
	import reflex.components.ScrollerDefinition;
	import reflex.data.Position;
	import reflex.layouts.BasicLayout;
	import reflex.skins.ScrollerSkin;
	
	public class Scroller extends ScrollerDefinition
	{
		
		public function Scroller()
		{
			horizontalPosition = new Position();
			verticalPosition = new Position();
			layout = new BasicLayout();
			skin = new ScrollerSkin();
			Bind.addBinding(this, "skin.container.content", this, "content");
			Bind.addBinding(this, "skin.container.layout", this, "layout");
			
			//Bind.addBinding(this, "skin.container.mask", this, "skin.mask");
			behaviors.addItem(new ScrollerBehavior(this));
		}
		
	}
}