package reflex.components
{
	import reflex.behaviors.ButtonBehavior;
	import reflex.behaviors.MovieClipSkinBehavior;
	import reflex.behaviors.SelectableBehavior;
	import reflex.skins.ButtonSkin;
	
	/**
	 * @alpha
	 **/
	public class Button extends Component
	{
		[Bindable]
		public var label:String;
		
		[Bindable]
		public var selected:Boolean;
		
		public function Button()
		{
			super();
			behaviors.button = new ButtonBehavior(this);
			behaviors.selectable = new SelectableBehavior(this);
			behaviors.movieclip = new MovieClipSkinBehavior(this);
			skin = new ButtonGraphic();
		}
		
	}
}