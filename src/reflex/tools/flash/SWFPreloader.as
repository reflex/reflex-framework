package reflex.tools.flash
{
  import flash.display.DisplayObject;
  import flash.display.LoaderInfo;
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.display.Stage;
  import flash.events.ErrorEvent;
  import flash.events.Event;
  import flash.events.ProgressEvent;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  
  import mx.core.RSLItem;
  import mx.core.RSLListLoader;
  import mx.events.RSLEvent;
  
  [Event(name="complete", type="Event")]
  public class SWFPreloader extends Sprite
  {
    protected var timer:Timer;
    protected var rslList:RSLListLoader;
    protected var rslDone:Boolean = false;
    protected var targetsLoaded:Boolean = false;
    protected var skin:DisplayObject;
    
    public function SWFPreloader()
    {
      super();
    }
    
    public function initialize(skinValue:Object = null, targets:Array = null):void
    {
      initSkin(skinValue);
      initTarget(targets);
    }
    
    /**
    * Positions the skin relative to the Stage. If the skin is an ISWFPreloaderSkin,
    * allow him to position himself. If not, set the x and y of the
    * ApplicationLoader to the center of the screen
    */
    public function positionLoader(stage:Stage):void
    {
      if(skin is ISWFPreloaderSkin)
      {
        ISWFPreloaderSkin(skin).position(stage);
      }
      else
      {
        x = (stage.stageWidth - width) / 2;
        y = (stage.stageHeight - height) / 2;
      }
    }
    
    protected function initTarget(targets:Array):void
    {
      if(targets && targets.length > 0)
      {
        rslDone = false;
        rslList = new RSLListLoader(targets);
        rslList.load(rslProgressHandler, rslCompleteHandler, rslErrorHandler, rslErrorHandler, rslErrorHandler);
      }
      else
        rslDone = true;
      
      if(!timer)
      {
        timer = new Timer(10);
        timer.addEventListener(TimerEvent.TIMER, checkProgressHandler);
        timer.start();
      }
    }
    
    /**
    * Initializes an IApplicationLoaderSkin instance passed in from the
    * ApplicationManager's info() method. If no instance is passed, uses
    * the default ApplicationLoaderSkin.
    * 
    * @param clazz Class that implements IApplicationLoaderSkin
    */
    protected function initSkin(skinValue:Object = null):void
    {
      // Don't initialize the skin twice.
      if(skin)
        return;
      
      if(skinValue == null)
        skinValue = SWFPreloaderSkin;
      
      if(skinValue is Class)
        skin = new (skinValue as Class)();
      else if(skinValue is DisplayObject)
        skin = skinValue as DisplayObject;
      else
        throw new ArgumentError("The skin for a SWFLoader must be a DisplayObject.");
      
      addChild(DisplayObject(skin));
    }
    
    /**
    * Checks the loading progress of the SWF and RSLs every 10 milliseconds.
    * Once all loading has completed, waits another 10 milliseconds to ensure
    * the classes are completely loaded into this ApplicationDomain and the
    * next frame is entirely baked.
    * 
    * @param event
    */
    protected function checkProgressHandler(event:TimerEvent):void
    {
      var bytes:Object = getByteValues();
      if(skin is ISWFPreloaderSkin)
      {
        ISWFPreloaderSkin(skin).progress = bytes.progress;
        ISWFPreloaderSkin(skin).total = bytes.total;
        ISWFPreloaderSkin(skin).validate();
      }
      else if(skin is MovieClip)
      {
        if(MovieClip(skin).totalFrames > 1)
          MovieClip(skin).gotoAndStop(Math.round((bytes.progress / bytes.total) * 100));
        else
          MovieClip(skin).play();
      }
      
      if(rslDone && bytes.progress >= bytes.total)
      {
        if(targetsLoaded)
        {
          // Clean up
          timer.stop();
          timer.removeEventListener(TimerEvent.TIMER, checkProgressHandler);
          timer = null;
          removeChild(DisplayObject(skin));
          targetsLoaded = false;
          // Complete
          dispatchEvent(new Event(Event.COMPLETE));
        }
        // Wait 10 milliseconds after the loading targets are finished 
        // to dispatch the COMPLETE event. This ensures the classes are
        // completely loaded into this ApplicationDomain, and the next
        // frame is entirely baked.
        else
        {
          targetsLoaded = true;
        }
      }
    }
    
    protected function getByteValues():Object
    {
      var li:LoaderInfo = root.loaderInfo;
      
      var loaded:Number = li.bytesLoaded;
      var total:Number = li.bytesTotal;
      
      if(rslList)
      {
        var i:int = 0;
        var n:int = rslList.getItemCount();
        var target:Object;
        for(; i < n; i++)
        {
          target = rslList.getItem(i);
          if(target.hasOwnProperty("bytesLoaded"))
            loaded += target.bytesLoaded;
          else if(target.hasOwnProperty("loaded"))
            loaded += target.loaded;
          if(target.hasOwnProperty("bytesTotal"))
            total += target.bytesTotal;
          else if(target.hasOwnProperty("total"))
            total += target.total;
        }
      }
      
      return{progress:loaded, total:total};
    }
    
    //////
    // RSL callbacks
    //////
    /**
     *  @private
     *  We don't listen for the events directly
     *  because we don't know which RSL is sending the event.
     *  So we have the RSLNode listen to the events
     *  and then pass them along to the Preloader.
     */
    protected function rslProgressHandler(event:ProgressEvent):void
    {
      var index:int = rslList.getIndex();
      var item:RSLItem = rslList.getItem(index);
      
      var rslEvent:RSLEvent = new RSLEvent(RSLEvent.RSL_PROGRESS);
      rslEvent.isResourceModule = false;
      rslEvent.bytesLoaded = event.bytesLoaded;
      rslEvent.bytesTotal = event.bytesTotal;
      rslEvent.rslIndex = index;
      rslEvent.rslTotal = rslList.getItemCount();
      rslEvent.url = item.urlRequest;
      dispatchEvent(rslEvent);
    }
    
    /**
     *  @private
     *  Load the next RSL in the list and dispatch an event.
     */
    protected function rslCompleteHandler(event:Event):void
    {
      var index:int = rslList.getIndex();
      var item:RSLItem = rslList.getItem(index);
      
      var rslEvent:RSLEvent = new RSLEvent(RSLEvent.RSL_COMPLETE);
      rslEvent.isResourceModule = false;
      rslEvent.bytesLoaded = item.total;
      rslEvent.bytesTotal = item.total;
      rslEvent.loaderInfo = event.target as LoaderInfo;
      rslEvent.rslIndex = index;
      rslEvent.rslTotal = rslList.getItemCount();
      rslEvent.url = item.urlRequest;
      dispatchEvent(rslEvent);
      
      rslDone = Boolean(index + 1 == rslEvent.rslTotal);
    }
    
    /**
     *  @private
     */
    protected function rslErrorHandler(event:ErrorEvent):void
    {
      // send an error event
      var index:int = rslList.getIndex();
      var item:RSLItem = rslList.getItem(index);
      var rslEvent:RSLEvent = new RSLEvent(RSLEvent.RSL_ERROR);
      
      rslEvent.isResourceModule = false;
      rslEvent.bytesLoaded = 0;
      rslEvent.bytesTotal = 0;
      rslEvent.rslIndex = index;
      rslEvent.rslTotal = rslList.getItemCount();
      rslEvent.url = item.urlRequest;
      rslEvent.errorText = decodeURI(event.text);
      dispatchEvent(rslEvent);
    }
  }
}