package reflex.skins
{
	import flight.binding.Bind;

	[DefaultProperty("backgrounds")]
	public class StatefulBackgroundSkin extends Skin
	{
		protected var _backgrounds:Object = {};
		protected var currentBackground:BackgroundSkin;
		
		public function StatefulBackgroundSkin()
		{
			Bind.addListener(this, onPropChange, this, "state");
		}
		
		protected function onPropChange(state:String):void
		{
			if (currentBackground) {
				currentBackground.target = null;
			}
			
			if (state in _backgrounds) {
				currentBackground = _backgrounds[state];
				currentBackground.target = target;
			}
		}
		
		public function set backgrounds(value:Vector.<BackgroundSkin>):void
		{
			for each (var background:BackgroundSkin in value) {
				_backgrounds[background.state] = background;
			}
			
			if (state in _backgrounds) {
				currentBackground = _backgrounds[state];
				currentBackground.target = target;
			}
		}
	}
	
	
}