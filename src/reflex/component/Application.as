package reflex.component
{
  import flash.display.StageAlign;
  import flash.display.StageQuality;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.ui.ContextMenu;
  
  import reflex.layout.Layout;
  
  [Frame(factoryClass="reflex.tools.flashbuilder.ReflexApplicationLoader")]
  
  public class Application extends Component
  {
    [Bindable]
    public var background:int = 0xEEEEEE;
    
    public function Application()
    {
    }
    
    override protected function init():void
    {
      super.init();
      
      contextMenu = new ContextMenu();
      contextMenu.hideBuiltInItems();
      stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
      onStageResize(null);
      
      addEventListener(Layout.LAYOUT, onLayout);
    }
    
    protected function draw():void
    {
      graphics.clear();
      graphics.beginFill(background);
      graphics.drawRect(0, 0, displayWidth, displayHeight);
      graphics.endFill();
    }
    
    private function onStageResize(event:Event):void
    {
      block.width = stage.stageWidth;
      block.height = stage.stageHeight;
    }
    
    private function onLayout(event:Event):void
    {
      draw();
    }
  }
}