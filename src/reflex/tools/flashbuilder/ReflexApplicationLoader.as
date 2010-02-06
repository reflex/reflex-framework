package reflex.tools.flashbuilder
{
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.display.Graphics;
  import flash.display.Loader;
  import flash.display.MovieClip;
  import flash.display.Stage;
  import flash.display.StageAlign;
  import flash.display.StageQuality;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.net.URLLoader;
  import flash.net.URLLoaderDataFormat;
  import flash.net.URLRequest;
  import flash.utils.Dictionary;
  import flash.utils.setTimeout;
  
  import mx.core.CrossDomainRSLItem;
  import mx.core.IFlexModuleFactory;
  import mx.core.RSLItem;
  import mx.utils.LoaderUtil;
  
  import reflex.tools.flash.ReflexFlashLoader;
  import reflex.tools.flash.SWFPreloader;
  
  public class ReflexApplicationLoader extends ReflexFlashLoader implements IFlexModuleFactory
  {
    public function ReflexApplicationLoader()
    {
      super(this, true);
    }
    
    override protected function initHandler(event:Event):void
    {
      super.initHandler(event);
      
      var allRSLs:Array = [];
      var info:Object = info();
      if(info)
      {
        //Load cdRSLs first then load RSLs
        if(info["cdRsls"])
          allRSLs = allRSLs.concat(initRSLS(info["cdRsls"]));
        if(info["rsls"])
          allRSLs = allRSLs.concat(initRSLS(info["rsls"]));
      }
      
      preloader.initialize(null, allRSLs);
    }
    
    /**
    * Utility function to create RSLItem or CrossDomainRSLItem objects
    * out of the objects the FB compiler generates.
    * 
    * @return Array of CrossDomainRSLItem or RSLItem objects.
    */
    protected function initRSLS(rsls:Object):Array
    {
      if(rsls == null)
        return[];
      
      var a:Array = [], r:RSLItem;
      for each(var rsl:Object in rsls)
      {
        if(rsl.hasOwnProperty("url"))
        {
          r = new RSLItem(rsl.url, LoaderUtil.normalizeURL(this.loaderInfo));
        }
        else if(rsl.hasOwnProperty("rsls"))
        {
          r = new CrossDomainRSLItem(rsl["rsls"],
                                     rsl["policyFiles"],
                                     rsl["digests"],
                                     rsl["types"],
                                     rsl["isSigned"],
                                     LoaderUtil.normalizeURL(this.loaderInfo));
        }
        
        a.push(r);
      }
      
      return a;
    }
    
    override protected function initializeApplication():void
    {
      // Caste with 'as' because create() can possibly return 'null',
      // and casting 'null' to a DisplayObject will throw an error
      var app:DisplayObject = create() as DisplayObject;
      
      // If there's no app, this is probably an app made in Flash Pro, 
      // in which case moving to the second frame is sufficient action
      // on our part.
      if(!app)
      {
        trace("no app");
        trace("currentFrame: " + currentFrame);
        return;
      }
      
      //The Application should listen for its own added_to_stage
      //event and initialize itself from that.
      addChild(app);
      
      super.initializeApplication();
      
      width = app.width = stage.stageWidth;
      height = app.height = stage.stageHeight;
    }
    
    public function get preloadedRSLs():Dictionary
    {
      return null;
    }
    
    public function allowDomain(... parameters):void
    {
    }
    
    public function allowInsecureDomain(... parameters):void
    {
    }
    
    public function callInContext(fn:Function, thisArg:Object, argArray:Array, returns:Boolean = true):*
    {
      return null;
    }
    
    public function create(... parameters):Object
    {
      return null;
    }
    
    public function getImplementation(interfaceName:String):Object
    {
      return null;
    }
    
    public function info():Object
    {
      return null;
    }
    
    public function registerImplementation(interfaceName:String, impl:Object):void
    {
    }
  }
}