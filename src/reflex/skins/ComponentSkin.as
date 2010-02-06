package reflex.skins
{
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  
  [DefaultProperty("content")]
  
  public class ComponentSkin extends Skin
  {
    public function ComponentSkin()
    {
      super();
    }
    
    override public function set target(value:Sprite):void
    {
      super.target = value;
      if(value)
        updateContent();
    }
    
    protected var _content:Array;
    public function get content():Array
    {
      return _content;
    }
    
    public function set content(value:Array):void
    {
      if(value === _content)
        return;
      
      _content = value;
      if(target)
        updateContent();
    }
    
    protected function updateContent():void
    {
      var i:int = 0;
      var n:int = content.length;
      var contentItem:Object;
      for(i = 0; i < n; i++)
      {
        contentItem = content[i];
        addSkinItemToTarget(contentItem);
      }
    }
    
    protected function addSkinItemToTarget(item:*):void
    {
      if(target is ISkinnable)
      {
        ISkinnable(target).addSkinPart(item);
      }
      else
      {
        if(item is DisplayObject)
          target.addChild(DisplayObject(item));
        else if(item is ISkin)
          ISkin(item).target = target;
      }
    }
  }
}