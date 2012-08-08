package reflex.components
{
	
	import flash.events.Event;
	
	import reflex.binding.Bind;
	import reflex.components.Component;
	import reflex.containers.HGroup;
	
	public class TitleBar extends Component
	{
		
		private var _title:String;
		
		[Bindable(event="titleChange")]
		public function get title():String { return _title; }
		public function set title(value:String):void {
			notify("title", _title, _title = value);
		}
		
		public function TitleBar()
		{
			super();
		}
		
		override protected function initialize():void {
			super.initialize();
			//skin = new TitleBarSkin();
			//measured.width = 640;
			//measured.height = 88;
			Bind.addBinding(this, "skin.currentState", this, "currentState", false);
		}
		
	}
}