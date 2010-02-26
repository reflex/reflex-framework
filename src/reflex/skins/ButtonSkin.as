package reflex.skins
{
	import flight.binding.Bind;
	import flight.events.PropertyEvent;
	
	import reflex.components.ButtonGraphic;
	import reflex.layout.Block;

	public class ButtonSkin extends GraphicSkin
	{
		[Bindable]
		public var label:String;
		
		[Bindable]
		public var selected:Boolean;
		
		private var buttonGraphic:ButtonGraphic;
		
		public function ButtonSkin(graphic:ButtonGraphic = null)
		{
			graphic = buttonGraphic = graphic || new ButtonGraphic()
			super(buttonGraphic);
			
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
			
			Bind.addListener(setLabel, this, "label");
		}
		
		private function setLabel(event:PropertyEvent):void
		{
			buttonGraphic.label.text = label || "";
		}
		
	}
}