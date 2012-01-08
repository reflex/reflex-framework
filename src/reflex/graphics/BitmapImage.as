package reflex.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import reflex.binding.DataChange;
	import reflex.display.BitmapDisplay;
	import reflex.invalidation.Invalidation;
	import reflex.metadata.resolveCommitProperties;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	
	public class BitmapImage extends BitmapDisplay
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
		private var _backgroundColor:uint = 0xFFFFFF;
		private var _backgroundAlpha:Number = 0;
		
		[Bindable(event="sourceChange")]
		public function get source():Object { return _source; }
		public function set source(value:Object):void {
			DataChange.change(this, "source", _source, _source = value);
		}
		
		[Bindable(event="scalingChanged")]
		public function get scaling():String { return _scaling; }
		public function set scaling(value:String):void {
			DataChange.change(this, "scaling", _scaling, _scaling = value);
		}
		
		[Bindable(event="backgroundColorChanged")]
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor(value:uint):void {
			DataChange.change(this, "backgroundColor", _backgroundColor, _backgroundColor = value);
		}
		
		[Bindable(event="backgroundAlphaChanged")]
		public function get backgroundAlpha():Number { return _backgroundAlpha; }
		public function set backgroundAlpha(value:Number):void {
			DataChange.change(this, "backgroundAlpha", _backgroundAlpha, _backgroundAlpha = value);
		}
		
		public function BitmapImage()
		{
			super();
			reflex.metadata.resolveCommitProperties(this, resolve);
		}
		
		/**
		 * @private
		 */
		[Commit(properties="source")]
		public function onSourceChanged(event:Event):void {
			if (source is String) {
				var request:URLRequest = new URLRequest(source as String);
				loader = new Loader();
				loader.load(request, new LoaderContext(true));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			} else if (source is Class) {
				var display:Object = new (source as Class)();
				if(display is Bitmap) {
					//var display:Bitmap = new (source as Class)();
					measured.width = display.width;
					measured.height = display.height;
					original = display.bitmapData;
				} else if(display is IBitmapDrawable) {
					var bitmap:BitmapData = new BitmapData(display.width, display.height, true, 0);
					bitmap.draw(display as IBitmapDrawable);
					measured.width = bitmap.width;
					measured.height = bitmap.height;
					original = bitmap;
				}
				draw();
			} else if (source is BitmapData) {
				var bitmapdata:BitmapData = source as BitmapData;
				measured.width = bitmapdata.width;
				measured.height = bitmapdata.height;
				original = bitmapdata;
				draw();
				Invalidation.invalidate(this, "measure");
				Invalidation.invalidate(this, "layout");
			} else {
				original = null;
				draw();
			}
		}
		
		private function onComplete(event:Event):void {
			measured.width = loader.content.width;
			measured.height = loader.content.height;
			original = (loader.content as Bitmap).bitmapData;
			draw();
			Invalidation.invalidate(this, "measure");
			Invalidation.invalidate(this, "layout");
		}
		
		/**
		 * @private
		 */
		[Commit(properties="width, height, scaling, backgroundColor, backgroundAlpha")]
		public function onSizeChange(event:Event):void {
			var color:uint = (_backgroundAlpha*255) << 24 | _backgroundColor
			this.bitmapData = new BitmapData(unscaledWidth, unscaledHeight, true, color);
			this.smoothing = true;
			draw();
		}
		
		private function draw():void {
			if (original) {
				var mode:String = _scaling;
				var matrix:Matrix;
				
				var originalRatio:Number = original.width/original.height;
				var bitmapRatio:Number = unscaledWidth/unscaledHeight;
				
				if (_scaling == BEST_FIT) {
					if (originalRatio > bitmapRatio) {
						mode = HORIZONTAL_FIT;
					} else {
						mode = VERTICAL_FIT;
					}
				} else if (_scaling == BEST_FILL) {
					if (originalRatio > bitmapRatio) {
						mode = VERTICAL_FIT;
					} else {
						mode = HORIZONTAL_FIT;
					}
				}
				
				if (mode == HORIZONTAL_FIT) {
					var hs:Number = unscaledWidth/original.width;
					matrix = new Matrix(hs, 0, 0, hs, 0, (original.height*hs - unscaledHeight)/2 * -1);
				} else if (mode == VERTICAL_FIT) {
					var vs:Number = unscaledHeight/original.height;
					matrix = new Matrix(vs, 0, 0, vs, (original.width*vs - unscaledWidth)/2 * -1, 0);
				} else if (mode == SKEW) {
					matrix = new Matrix(unscaledWidth/original.width, 0, 0, unscaledHeight/original.height, 0, 0);
				}
				if(bitmapData) {
					bitmapData.floodFill(0, 0, 0)
					bitmapData.draw(original, matrix, null, null, null, true);
				}
			} else {
				if(bitmapData) {
					bitmapData.floodFill(0, 0, 0)
				}
			}
		}
		
		private function resolve(m:String):* {
			var t:* = this[m];
			return t;
		}
		
	}
}