package reflex.components
{
	import reflex.behaviors.ButtonBehavior;
	import reflex.behaviors.MovieClipSkinBehavior;
	import reflex.behaviors.SelectableBehavior;
	import reflex.skins.ButtonSkin;
	import flash.display.MovieClip;
	
	/**
	 * @alpha
	 **/
	public class Button extends Component
	{
		
		private var _label:String;
		
		[Bindable]
		[Inspectable(name="Label", type=String, defaultValue="Label")]
		public function get label():String { return _label; }
		public function set label(value:String):void {
			_label = value;
			if(skin is ButtonGraphic) {
				(skin as ButtonGraphic).label.text = label;
			}
		}
		
		[Bindable]
		[Inspectable(name="Selected", type=Boolean, defaultValue=false)]
		public var selected:Boolean;
		
		public function Button()
		{
			super();
			behaviors.button = new ButtonBehavior(this);
			behaviors.selectable = new SelectableBehavior(this);
			behaviors.movieclip = new MovieClipSkinBehavior(this);
			if(this is MovieClip) {
				skin = this;
			} else {
				skin = new ButtonGraphic();
			}
			
		}
		
	}
}