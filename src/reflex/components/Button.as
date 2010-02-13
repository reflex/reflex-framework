package reflex.components
{
	import flight.binding.Bind;
	
	import reflex.behaviors.ButtonBehavior;
	import reflex.behaviors.SelectableBehavior;
	import reflex.layout.Block;
	import reflex.skins.GraphicSkin;
	
	[DefaultProperty("label")]
	public class Button extends Component
	{
		[Bindable] public var label:String;
		[Bindable] public var selected:Boolean;
		
		public function Button()
		{
			var graphic:ButtonGraphic = new ButtonGraphic();
			var block:Block = new Block(graphic.background);
			block.scale = true;
			block.anchor = 0;
			block = new Block(graphic.foreground);
			block.scale = true;
			block.anchor = 0;
			block.anchor.bottom = NaN;
			block.anchor.vertical = .5;
			block.anchor.offsetY = 10;
			block = new Block(graphic.label);
			block.scale = true;
			block.anchor.left = block.anchor.right = 0;
			block.anchor.vertical = .5;
			
			skin = new GraphicSkin(graphic);
			new ButtonBehavior(this);
			new SelectableBehavior(this);
//			Bind.addBinding(buttonGraphic.label, "text", graphicSkin, "data");
		}
		
	}
}