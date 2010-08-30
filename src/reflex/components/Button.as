package reflex.components
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import flight.events.PropertyEvent;
	
	import reflex.behaviors.ButtonBehavior;
	import reflex.behaviors.MovieClipSkinBehavior;
	import reflex.behaviors.SelectableBehavior;
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
			if(skin is ButtonGraphic) { // wow, this shouldn't be here at all
				(skin as ButtonGraphic).label.text = label != null ? label : "";
			}
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
			// this hard coding shouldn't be here
			behaviors.button = new ButtonBehavior(this);
			behaviors.selectable = new SelectableBehavior(this);
			behaviors.movieclip = new MovieClipSkinBehavior(this);
			if(skin == null) {
				if(this is MovieClip) {
					skin = this;
				} else {
					skin = new ButtonGraphic();
				}
			}
		}
		
	}
}