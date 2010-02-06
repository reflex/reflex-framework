package reflex.tools.flash
{
  import flash.display.Stage;

  public interface ISWFPreloaderSkin
  {
    function get height():Number;
    function get width():Number;
    function get x():Number;
    function get y():Number;
    
    function set label(value:String):void;
    function set total(value:Number):void;
    function set progress(value:Number):void;
    
    function set height(value:Number):void;
    function set width(value:Number):void;
    function set x(value:Number):void;
    function set y(value:Number):void;
    
    // Allow the skin to position himself relative to the stage.
    function position(stage:Stage):void;
    function validate():void;
  }
}