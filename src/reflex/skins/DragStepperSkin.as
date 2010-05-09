package reflex.skins
{
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	import flight.binding.Bind;
	import flight.position.IPosition;
	
	import reflex.components.DragStepperGraphic;
	import reflex.cursors.Cursor;

	public class DragStepperSkin extends GraphicSkin
	{
		[Bindable]
		public var position:IPosition;
		
		private var stepperGraphic:DragStepperGraphic;
		
		public function DragStepperSkin(graphic:DragStepperGraphic = null)
		{
			graphic = stepperGraphic = graphic || new DragStepperGraphic()
			super(stepperGraphic);
			
			stepperGraphic.label.defaultTextFormat = new TextFormat(null, null, null, null, null, true);
			
			Bind.addBinding(this, "position", this, "target.position");
			Bind.addListener(this, updateLabel, this, "position.value");
			Bind.addListener(this, onTargetChange, this, "target");
		}
		
		protected function onTargetChange(oldTarget:Sprite, newTarget:Sprite):void
		{
			if (oldTarget) Cursor.useCursor(oldTarget, Cursor.AUTO);
			if (newTarget) Cursor.useCursor(newTarget, Cursor.EAST_WEST);
		}
		
		protected function updateLabel(position:int):void
		{
			stepperGraphic.label.text = String(position);
		}
	}
}