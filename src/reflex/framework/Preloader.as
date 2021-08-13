package reflex.framework
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	public class Preloader extends MovieClip
	{
		
		//[Embed(source="Default.png")]
		//private var splashScreenImage:Class;
		//private var splashScreen:Bitmap;
		
		public function Preloader()
		{
			stop();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			//loaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			//loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// Show Splash Screen
			//stage.addEventListener(Event.DEACTIVATE, deactivate);
			//splashScreen = new splashScreenImage() as Bitmap;
			//addChild( splashScreen );
			
			//Resize Splash screen to fit the screen (comment this out if you don't want the graphic resized)
			/*var wScale:Number = stage.stageWidth / splashScreen.width;
			var hScale:Number = stage.stageHeight / splashScreen.height;
			if (wScale < hScale) {
				splashScreen.scaleX = wScale;
				splashScreen.scaleY = wScale;
			}else {
				splashScreen.scaleX = hScale;
				splashScreen.scaleY = hScale;
			}
			
			//Position splash screen
			splashScreen.x = (stage.stageWidth - splashScreen.width) / 2;
			splashScreen.y = (stage.stageHeight - splashScreen.height) / 2;
			*/
		}
		/*
		private function ioError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		*/
		
		
		
		private function onEnterFrame(event:Event):void
		{
			// TODO update loader
			graphics.clear();
			if(framesLoaded == totalFrames) {
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame, false);
				try{
					this.nextFrame(); // flex throws some weird mojo in here
				} catch(e:Error) {}
				
				var name:String = this.currentLabels[1].name;
				var APP:Class = getDefinitionByName(name) as Class;
				var instance:Object = new APP();
				stage.addChild(instance as DisplayObject);
				instance.initialize(null);
			} else {
				var percent:Number = Math.round(this.loaderInfo.bytesLoaded / this.loaderInfo.bytesTotal);
				graphics.beginFill(0, 1.0);
				graphics.drawRect(0, stage.stageHeight/2-10, stage.stageWidth*percent, 20);
				graphics.endFill();
			}
		}
		/*
		private function onComplete(event:Event):void
		{
			//removeEventListener(Event.ENTER_FRAME, enterFrame);
			//loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			//loaderInfo.removeEventListener(Event.COMPLETE, onComplete, false);
			//loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// Hide SplashScreen
			//removeChild( splashScreen );
			//splashScreen.bitmapData.dispose();
			//splashScreen = null;
			//splashScreenImage = null;
			
			startup();
		}
		*/
		/*
		private function deactivate(e:Event):void
		{
			// auto-close
			NativeApplication.nativeApplication.exit();
		}
		*/
	}
}