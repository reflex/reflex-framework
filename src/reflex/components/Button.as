package reflex.components
{
	
	import flash.events.Event;
	
	import reflex.binding.Bind;

	public class Button extends Component
	{
		
		private var _icon:Object;
		private var _label:String;
		private var _selected:Boolean;
		
		[Bindable(event="iconChange")]
		public function get icon():Object { return _icon; }
		public function set icon(value:Object):void {
			notify("icon", _icon, _icon = value);
		}
		
		[Bindable(event="labelChange")]
		[Inspectable(name="Label", type=String, defaultValue="Label")]
		public function get label():String { return _label; }
		public function set label(value:String):void {
			notify("label", _label, _label = value);
		}
		
		[Bindable(event="selectedChange")]
		[Inspectable(name="Selected", type=Boolean, defaultValue=false)]
		public function get selected():Boolean {return _selected; }
		public function set selected(value:Boolean):void {
			notify("selected", _selected, _selected = value);
		}
		
		public function Button(label:String = "")
		{
			super();
			this.label = label;
		}
		
		override protected function initialize():void {
			super.initialize();
			Bind.addBinding(this, "skin.iconDisplay.source", this, "icon", false);
			Bind.addBinding(this, "skin.labelDisplay.text", this, "label", false);
			Bind.addBinding(this, "skin.currentState", this, "currentState", false);
		}
		
	}
}