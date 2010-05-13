package reflex.display
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import reflex.events.InvalidationEvent;

	public class ImageDisplay extends ReflexDisplay
	{
		
		public static const MEASURE:String = "measure";
		public static const SOURCE_CHANGED:String = "sourceChanged";
		
		InvalidationEvent.registerPhase(SOURCE_CHANGED, 0, true);
		
		private var loader:Loader;
		
		private var _source:Object; [Bindable]
		public function get source():Object { return _source; }
		public function set source(value:Object):void {
			_source = value;
			InvalidationEvent.invalidate(this, SOURCE_CHANGED);
		}
		
		public function ImageDisplay()
		{
			super();
			addEventListener(SOURCE_CHANGED, onSourceChanged, false, 0, true);
			addEventListener(MEASURE, onMeasure, false, 0, true);
		}
		
		private function onSourceChanged(event:InvalidationEvent):void {
			var request:URLRequest = new URLRequest(source as String);
			loader = new Loader();
			loader.load(request);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
		}
		
		private function onComplete(event:Event):void {
			measurements.measuredWidth = loader.content.width;
			measurements.measuredHeight = loader.content.height;
			setSize(measurements.measuredWidth, measurements.measuredHeight);
			addChild(loader);
		}
		
		private function onMeasure(event:InvalidationEvent):void {
			
		}
		
	}
}