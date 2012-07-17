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
	
	import reflex.display.MeasurableItem;
	import reflex.invalidation.Invalidation;
	import reflex.invalidation.LifeCycle;
	import reflex.metadata.resolveCommitProperties;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	
	public class BitmapImage extends MeasurableItem
	{
		
		static public const BEST_FIT:String = "bestFit";
		static public const BEST_FILL:String = "bestFill";
		static public const HORIZONTAL_FIT:String = "horizontalFit";
		static public const VERTICAL_FIT:String = "verticalFit";
		static public const SKEW:String = "skew";
		
		private var loader:Loader;
		private var original:BitmapData;
		private var bitmap:Bitmap;
		
		private var _source:Object;
		private var _scaling:String = BEST_FILL;
		private var _backgroundColor:uint = 0xFFFFFF;
		private var _backgroundAlpha:Number = 0;
		
		[Bindable(event="sourceChange")]
		public function get source():Object { return _source; }
		public function set source(value:Object):void {
			notify("source", _source, _source = value);
			invalidate(LifeCycle.INVALIDATE);
		}
		
		[Bindable(event="scalingChanged")]
		public function get scaling():String { return _scaling; }
		public function set scaling(value:String):void {
			notify("scaling", _scaling, _scaling = value);
		}
		
		[Bindable(event="backgroundColorChanged")]
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor(value:uint):void {
			notify("backgroundColor", _backgroundColor, _backgroundColor = value);
		}
		
		[Bindable(event="backgroundAlphaChanged")]
		public function get backgroundAlpha():Number { return _backgroundAlpha; }
		public function set backgroundAlpha(value:Number):void {
			notify("backgroundAlpha", _backgroundAlpha, _backgroundAlpha = value);
		}
		
		public function BitmapImage()
		{
			super();
			//reflex.metadata.resolveCommitProperties(this, resolve);
			this.addEventListener(LifeCycle.INVALIDATE, onInvalidate);
		}
		
		private function onInvalidate(event:Event):void {
			onSourceChanged(event);
		}
		
		/**
		 * @private
		 */
		//[Commit(properties="source")]
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
					_measuredWidth = display.width;
					_measuredHeight = display.height;
					this.setSize(_measuredWidth, _measuredHeight);
					original = display.bitmapData;
				} else if(display is IBitmapDrawable) {
					var bitmap:BitmapData = new BitmapData(display.width, display.height, true, 0);
					bitmap.draw(display as IBitmapDrawable);
					_measuredWidth = bitmap.width;
					_measuredHeight = bitmap.height;
					this.setSize(_measuredWidth, _measuredHeight);
					original = bitmap;
				}
				draw();
			} else if (source is BitmapData) {
				var bitmapdata:BitmapData = source as BitmapData;
				_measuredWidth = bitmapdata.width;
				_measuredHeight = bitmapdata.height;
				this.setSize(_measuredWidth, _measuredHeight);
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
			_measuredWidth = loader.content.width;
			_measuredHeight = loader.content.height;
			original = (loader.content as Bitmap).bitmapData;
			draw();
			Invalidation.invalidate(this, "measure");
			Invalidation.invalidate(this, "layout");
		}
		
		/**
		 * @private
		 */
		//[Commit(properties="width, height, scaling, backgroundColor, backgroundAlpha")]
		public function onSizeChange(event:Event):void {
			var color:uint = (_backgroundAlpha*255) << 24 | _backgroundColor
			//this.bitmapData = new BitmapData(unscaledWidth, unscaledHeight, true, color);
			//this.smoothing = true;
			draw();
		}
		
		private function draw():void {
			if(display == null) { return; }
			if(bitmap == null) {
				bitmap = new Bitmap();
				display.addChild(bitmap);
			}
			if(bitmap.bitmapData == null) {
				bitmap.bitmapData = new BitmapData(width, height, true, 0);
			}
			
			var bitmapData:BitmapData = bitmap.bitmapData;
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
				
				bitmapData.floodFill(0, 0, 0)
				bitmapData.draw(original, matrix, null, null, null, true);
			} else {
				bitmapData.floodFill(0, 0, 0)
			}
		}
		
		private function resolve(m:String):* {
			var t:* = this[m];
			return t;
		}
		
	}
}