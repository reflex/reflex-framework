package reflex.skins
{
	import flash.display.FrameLabel;
	
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
			graphic.cacheAsBitmap = true;
			
			Bind.addBinding(this, "selected", this, "target.selected");
			removeStatefulChild(graphic);
			addStatefulChild(graphic.background);
			addStatefulChild(graphic.foreground);
			
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
			
			Bind.addListener(this, setLabel, this, "label");
			Bind.addListener(this, onSelectedChange, this, "selected");
		}
		
		protected function setLabel(label:String):void
		{
			buttonGraphic.label.text = label || "";
		}
		
		override protected function gotoState(state:String):void
		{
			super.gotoState(selected ? "selected" : state);
		}
		
		protected function onSelectedChange(selected:Boolean):void
		{
			super.gotoState(selected ? "selected" : currentState);
		}
	}
}