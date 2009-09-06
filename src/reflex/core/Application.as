package reflex.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	//[DefaultProperty(name="content")]
	public class Application extends Sprite implements IContainer
	{
		
		private var _content:Array;
		public function get content():Array { return _content; }
		public function set content(value:Array):void {
			_content = value;
			updateChildren(_content);
		}
		
		//public var profile:Object;
		
		public function Application()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.BEST;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
			updateDisplayList(stage.stageWidth, stage.stageHeight);
		}
		
		protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			/*graphics.beginFill(0xFF0000, 1);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();*/
		}
		
		private function resizeHandler(event:Event):void {
			updateDisplayList(stage.stageWidth, stage.stageHeight);
		}
		
		private function updateChildren(children:Array):void {
			var length:int = children.length;
			for(var i:int = 0; i < length; i++) {
				var child:DisplayObject = children[i];
				if(child) {
					this.addChild(child);
				}
			}
		}
		
	}
}