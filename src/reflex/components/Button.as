package reflex.components
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import reflex.behaviors.ButtonBehavior;
	import reflex.behaviors.MovieClipSkinBehavior;
	import reflex.behaviors.SelectableBehavior;
	import reflex.binding.Bind;
	import reflex.events.PropertyEvent;
	import reflex.measurement.setSize;
	
	/**
	 * @alpha
	 **/
	public class Button extends Component
	{
		
		private var _label:String;
		private var _selected:Boolean;
		
		[Bindable(event="labelChange")]
		[Inspectable(name="Label", type=String, defaultValue="Label")]
		public function get label():String { return _label; }
		public function set label(value:String):void {
			if(_label == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "label", _label, _label = value);
		}
		
		[Bindable(event="selectedChange")]
		[Inspectable(name="Selected", type=Boolean, defaultValue=false)]
		public function get selected():Boolean {return _selected; }
		public function set selected(value:Boolean):void {
			if(_selected == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "selected", _selected, _selected = value);
		}
		
		public function Button()
		{
			super();
			//skin = this;
			Bind.addBinding(this, "skin.label.text", this, "label", false);
		}
		
	}
}