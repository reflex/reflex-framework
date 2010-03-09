package reflex.skins
{
	import flight.binding.Bind;
	import flight.position.IPosition;
	
	import reflex.components.StepperGraphic;

	public class StepperSkin extends GraphicSkin
	{
		[Bindable]
		public var position:IPosition;
		
		private var stepperGraphic:StepperGraphic;
		
		public function StepperSkin(graphic:StepperGraphic = null)
		{
			graphic = stepperGraphic = graphic || new StepperGraphic()
			super(stepperGraphic);
			
			stepperGraphic.label.borderColor = 0x999999;
			
			Bind.addBinding(this, "position", this, "target.position");
			Bind.addListener(this, updateLabel, this, "position.value");
		}
		
		protected function updateLabel(position:int):void
		{
			stepperGraphic.label.text = String(position);
		}
	}
}