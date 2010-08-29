package reflex.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	
	import flight.events.PropertyEvent;
	
	import reflex.events.InvalidationEvent;
	import reflex.metadata.resolveCommitProperties;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	
	public class ImageDisplay extends StyleableBitmap
	{
		
		static public const BEST_FIT:String = "bestFit";
		static public const BEST_FILL:String = "bestFill";
		static public const HORIZONTAL_FIT:String = "horizontalFit";
		static public const VERTICAL_FIT:String = "verticalFit";
		static public const SKEW:String = "skew";
		
		private var loader:Loader;
		private var original:BitmapData;
		
		private var _source:Object;
		private var _scaling:String = BEST_FILL;
		
		[Bindable(event="sourceChange")]
		public function get source():Object { return _source; }
		public function set source(value:Object):void {
			if(_source == value) {
				return
			}
			PropertyEvent.dispatchChange(this, "source", _source, _source = value);
		}
		
		[Bindable(event="scalingChanged")]
		public function get scaling():String { return _scaling; }
		public function set scaling(value:String):void {
			if(_scaling == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "scaling", _scaling, _scaling = value);
		}
		
		public function ImageDisplay()
		{
			super();
			reflex.metadata.resolveCommitProperties(this, resolve);
		}
		
		[CommitProperties(target="source")]
		public function onSourceChanged(event:InvalidationEvent):void {
			if(source is String) {
				var request:URLRequest = new URLRequest(source as String);
				loader = new Loader();
				loader.load(request);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			} else if(source is Class) {
				var display:Bitmap = new (source as Class)();
				measured.width = display.width;
				measured.height = display.height;
				original = display.bitmapData;
				draw();
			}
		}
		
		private function onComplete(event:Event):void {
			measured.width = loader.content.width;
			measured.height = loader.content.height;
			original = (loader.content as Bitmap).bitmapData;
			draw();
		}
		
		[CommitProperties(target="width, height, scaling")]
		public function onSizeChange(event:InvalidationEvent):void {
			this.bitmapData = new BitmapData(unscaledWidth, unscaledHeight, true, 0x00000000);
			this.smoothing = true;
			draw();
		}
		
		private function draw():void {
			if(original) {
				var mode:String = _scaling;
				var matrix:Matrix;
				
				var originalRatio:Number = original.width/original.height;
				var bitmapRatio:Number = unscaledWidth/unscaledHeight;
				
				if(_scaling == BEST_FIT) {
					if(originalRatio > bitmapRatio) {
						mode = HORIZONTAL_FIT;
					} else {
						mode = VERTICAL_FIT;
					}
				} else if(_scaling == BEST_FILL) {
					if(originalRatio > bitmapRatio) {
						mode = VERTICAL_FIT;
					} else {
						mode = HORIZONTAL_FIT;
					}
				}
				
				if(mode == HORIZONTAL_FIT) {
					var hs:Number = unscaledWidth/original.width;
					matrix = new Matrix(hs, 0, 0, hs, 0, (original.height*hs - unscaledHeight)/2 * -1);
				} else if(mode == VERTICAL_FIT) {
					var vs:Number = unscaledHeight/original.height;
					matrix = new Matrix(vs, 0, 0, vs, (original.width*vs - unscaledWidth)/2 * -1, 0);
				} else if(mode == SKEW) {
					matrix = new Matrix(unscaledWidth/original.width, 0, 0, unscaledHeight/original.height, 0, 0);
				}
				this.bitmapData.draw(original, matrix, null, null, null, true);
			}
		}
		
		private function resolve(m:String):* {
			var t:* = this[m];
			return t;
		}
		
	}
}