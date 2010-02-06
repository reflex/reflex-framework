package reflex.tools.flash
{
  import flash.display.Graphics;
  import flash.display.Sprite;
  import flash.display.Stage;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  import flash.text.TextLineMetrics;
  
  public class SWFPreloaderSkin extends Sprite implements ISWFPreloaderSkin
  {
    protected var _progress:Number = 0;
    protected var _total:Number = 1;
    protected var _label:String = "";
    protected var _text:TextField;
    
    public function SWFPreloaderSkin()
    {
      super();
      
      width = 210;
      height = 35;
      
      _text = new TextField();
      _text.autoSize = TextFieldAutoSize.LEFT;
      _text.text = "Loading"
      addChild(_text);
    }
    
    private var _width:Number = 0;
    override public function get width():Number
    {
      return _width;
    }
    override public function set width(value:Number):void
    {
      _width = value;
    }
    
    private var _height:Number = 0;
    override public function get height():Number
    {
      return _height;
    }
    override public function set height(value:Number):void
    {
      _height = value;
    }
    
    public function set progress(value:Number):void
    {
      _progress = value;
    }
    
    public function set total(value:Number):void
    {
      _total = value;
    }
    
    public function set label(value:String):void
    {
      _label = value;
    }
    
    protected function get ratio():Number
    {
      return _progress/_total;
    }
    
    /**
    * Position the skin relative to the stage. Sets the skin
    * to the center of the stage. Can be overridden to set him
    * anywhere.
    */
    public function position(stage:Stage):void
    {
      x = (stage.stageWidth - width) / 2;
      y = (stage.stageHeight - height) / 2;
    }
    
    public function validate():void
    {
      trace("preloader skin update");
      
      var g:Graphics = graphics;
      g.clear();
      
      //Draw the background
      g.lineStyle(1, 0x000000);
      g.beginFill(0x999999, 1);
      g.drawRect(0, 0, width, height);
      
      //Draw the progress bar
      g.lineStyle(0, 0x000000, 0);
      g.beginFill(0x000000, 1);
      g.drawRect(5, 15, ratio * width - 10, 5);
      
      var tlm:TextLineMetrics = _text.getLineMetrics(0);
      _text.text = _label;
      _text.x = (width/tlm.width) / 2;
      _text.y = 21;
    }
  }
}