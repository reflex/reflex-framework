package reflex.skins
{
	import flight.binding.Bind;

	[DefaultProperty("backgrounds")]
	public class StatefulBackgroundSkin extends BackgroundSkin
	{
		protected var _backgrounds:Object = {};
		protected var currentBackground:BackgroundSkin;
		
		public function StatefulBackgroundSkin()
		{
			Bind.addListener(this, onStateChange, this, "state");
		}
		
		protected function onStateChange(state:String):void
		{
			if (currentBackground) {
				currentBackground.target = null;
			}
			
			if (state in _backgrounds) {
				currentBackground = _backgrounds[state];
				currentBackground.target = target;
			}
		}
		
		private var props:Array = ["backgroundColors", "backgroundAlphas", "backgroundRatios", "backgroundAngle",
				"borderColors", "borderAlphas", "borderRatios", "borderAngle", "borderWidth", "radius"];
		public function set backgrounds(value:Vector.<BackgroundSkin>):void
		{
			for each (var background:BackgroundSkin in value) {
				for each (var prop:String in props) {
					if (this[prop] && !background[prop]) {
						background[prop] = this[prop];
					}
				}
				
				_backgrounds[background.state] = background;
			}
			
			if (state in _backgrounds) {
				currentBackground = _backgrounds[state];
				currentBackground.target = target;
			}
		}
	}
	
	
}