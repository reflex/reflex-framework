package reflex.tools.flash
{
  import flash.display.DisplayObjectContainer;
  import flash.display.MovieClip;
  import flash.display.Stage;
  import flash.display.StageAlign;
  import flash.display.StageQuality;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.utils.setTimeout;
  
  public class ReflexFlashLoader extends MovieClip
  {
    protected var preloader:SWFPreloader;
    protected var preloaderSkin:Object;
    protected var loadingComplete:Boolean = false;
    
    public function ReflexFlashLoader(root:MovieClip, useLoader:Boolean = true, loaderSkinOrClass:Object = null)
    {
      if(root.stage)
        initStage(root.stage);
      
      if(loaderSkinOrClass == null)
        loaderSkinOrClass = SWFPreloaderSkin;
      
      preloaderSkin = loaderSkinOrClass;
      
      // If this is a multi-frame movie, stop on frame 1
      // so we can show progress of RSLs and the rest of
      // the movie. If it's a single frame movie, stopping
      // here is no problem.
      root.stop();
      
      if(root.totalFrames > 1 && root && root.loaderInfo)
        root.loaderInfo.addEventListener(Event.INIT, initHandler);
    }
    
    /**
    * Utility method to instantiate the loader in Flash
    */
    public static function init(root:MovieClip, useLoader:Boolean = true, loaderSkinClass:Class = null):void
    {
      root.addChild(new ReflexFlashLoader(root, useLoader, loaderSkinClass));
    }
    
    /**
     * Utility function to set usual stage properties.
     */
    public static function initStage(stage:Stage):void
    {
      stage.frameRate = 30;
      stage.quality = StageQuality.BEST;
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
    }
    
    override public function get stage():Stage
    {
      if(root === this)
        return super.stage;
      
      return root.stage;
    }
    
    override public function get currentFrame():int
    {
      if(root === this)
        return super.currentFrame;
      
      return MovieClip(root).currentFrame;
    }
    
    override public function get currentFrameLabel():String
    {
      if(root === this)
        return super.currentFrameLabel;
      
      return MovieClip(root).currentFrameLabel;
    }
    
    override public function get totalFrames():int
    {
      if(root === this)
        return super.totalFrames;
      
      return MovieClip(root).totalFrames;
    }
    
    override public function get framesLoaded():int
    {
      if(root === this)
        return super.framesLoaded;
      
      return MovieClip(root).framesLoaded;
    }
    
    override public function nextFrame():void
    {
      if(root === this)
        return super.nextFrame();
      
      MovieClip(root).nextFrame();
    }
    
    override public function stop():void
    {
      if(root === this)
        return super.stop();
      
      MovieClip(root).stop();
    }
    
    protected function initHandler(event:Event):void
    {
      width = stage.stageWidth;
      height = stage.stageHeight;
      
      event.target.removeEventListener(event.type, initHandler);
      addEventListener(Event.ENTER_FRAME, concurrentEnterFrameHandler);
      
      preloader = new SWFPreloader();
      preloader.addEventListener(Event.COMPLETE, preloaderCompleteHandler);
      preloader.initialize(preloaderSkin);
      
      DisplayObjectContainer(root).addChild(preloader);
      //Allow the preloader to position his skin based on the stage.
      preloader.positionLoader(stage);
    }
    
    protected function preloaderCompleteHandler(event:Event):void
    {
      preloader.removeEventListener(Event.COMPLETE, preloaderCompleteHandler);
      loadingComplete = true;
      
      DisplayObjectContainer(root).removeChild(preloader);
      
      moveToNextFrame();
    }
    
    /**
     * Moves to the next frame if the next frame is baked. If not,
     * waits 100 milliseconds and tries again.
     */
    protected function moveToNextFrame():void
    {
      if(currentFrame + 1 > totalFrames)
        return;
      
      if(currentFrame + 1 <= framesLoaded)
      {
        nextFrame();
      }
      else
        setTimeout(moveToNextFrame, 100);
    }
    
    protected function concurrentEnterFrameHandler(event:Event):void
    {
      if(currentFrame >= 2 && loadingComplete)
      {
        removeEventListener(event.type, concurrentEnterFrameHandler);
        initializeApplication();
      }
    }
    
    protected function initializeApplication():void
    {
    }
  }
}