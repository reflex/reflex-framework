package reflex.components
{
	
	import flash.events.Event;
	
	import reflex.binding.Bind;
	import reflex.components.Component;
	import reflex.containers.HGroup;
	
	public class StatusBar extends Component
	{
		
		public function StatusBar()
		{
			super();
			
		}
		
		override protected function initialize():void {
			super.initialize();
			//skin = new StatusBarSkin();
			//measured.width = 640;
			//measured.height = 40;
			Bind.addBinding(this, "skin.currentState", this, "currentState", false);
		}
		
	}
}