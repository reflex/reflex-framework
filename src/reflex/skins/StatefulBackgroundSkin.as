package reflex.skins
{
	import flash.display.Sprite;
	
	import flight.binding.Bind;

	[DefaultProperty("backgrounds")]
	public class StatefulBackgroundSkin extends Skin
	{
		public var backgroundColors:String;
		public var backgroundAlphas:String;
		public var backgroundRatios:String;
		public var backgroundAngle:String;
		public var borderColors:String;
		public var borderAlphas:String;
		public var borderRatios:String;
		public var borderAngle:String;
		public var borderWidth:Number;
		public var radius:String;
		
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
				
				_backgrounds[background.currentState] = background;
			}
			
			if (currentState in _backgrounds) {
				currentBackground = _backgrounds[currentState];
				currentBackground.target = target;
			}
		}
	}
	
	
}