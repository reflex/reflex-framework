package reflex.display
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import flight.events.PropertyEvent;
	
	import reflex.events.InvalidationEvent;
	
	public class ImageDisplay extends MeasuredSprite
	{
		
		public static const MEASURE:String = "measure";
		public static const SOURCE_CHANGED:String = "sourceChanged";
		
		InvalidationEvent.registerPhase(SOURCE_CHANGED, 0, true);
		
		private var loader:Loader;
		
		private var _source:Object;
		
		[Bindable(event="sourceChange")]
		public function get source():Object { return _source; }
		public function set source(value:Object):void {
			if(_source == value) {
				return
			}
			var oldSource:Object = _source;
			_source = value;
			InvalidationEvent.invalidate(this, SOURCE_CHANGED);
			PropertyEvent.dispatchChange(this, "source", oldSource, _source);
		}
		
		public function ImageDisplay()
		{
			super();
			addEventListener(SOURCE_CHANGED, onSourceChanged, false, 0, true);
			//addEventListener(MEASURE, onMeasure, false, 0, true);
		}
		
		private function onSourceChanged(event:InvalidationEvent):void {
			if(source is String) {
				var request:URLRequest = new URLRequest(source as String);
				loader = new Loader();
				loader.load(request);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			} else if(source is Class) {
				var display:Bitmap = new (source as Class)();
				measured.width = display.width;
				measured.height = display.height;
				setSize(measured.width, measured.height);
				addChild(display);
			}
		}
		
		private function onComplete(event:Event):void {
			measured.width = loader.content.width;
			measured.height = loader.content.height;
			setSize(measured.width, measured.height);
			addChild(loader);
		}
		/*
		private function onMeasure(event:InvalidationEvent):void {
			
		}
		*/
	}
}