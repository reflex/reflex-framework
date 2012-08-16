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
		private var splashScreenImage:Class;
		private var splashScreen:Bitmap;
		
		public function Preloader()
		{
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// Show Splash Screen
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			splashScreen = new splashScreenImage() as Bitmap;
			addChild( splashScreen );
			
			//Resize Splash screen to fit the screen (comment this out if you don't want the graphic resized)
			var wScale:Number = stage.stageWidth / splashScreen.width;
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
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void
		{
			// TODO update loader
		}
		
		private function checkFrame(e:Event):void
		{
			if (currentFrame == totalFrames)
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// Hide SplashScreen
			removeChild( splashScreen );
			splashScreen.bitmapData.dispose();
			splashScreen = null;
			splashScreenImage = null;
			
			startup();
		}
		
		private function startup():void
		{
			stage.removeEventListener(Event.DEACTIVATE, deactivate);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			var instance:Object = new mainClass();
			addChild(instance as DisplayObject);
		}
		
		private function deactivate(e:Event):void
		{
			// auto-close
			NativeApplication.nativeApplication.exit();
		}
		
	}
}