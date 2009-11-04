package reflex.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[DefaultProperty(name="content")]
	public class Application extends Sprite implements IContainer
	{
		public var background:Number = 0xEEEEEE
		
		protected var unscaledWidth:Number = 0;
		protected var unscaledHeight:Number = 0;
		
		private var _content:Array;
		public function get content():Array { return _content; }
		public function set content(value:Array):void {
			_content = value;
			updateChildren(_content);
		}
		
		public function Application()
		{
			stage.align = StageAlign.TOP_LEFT;
			// NOTE: "bitmaps are always smoothed" vs "bitmaps are smoothed if the movie is static"
			// ... is this a noticable quality improvement?
			stage.quality = StageQuality.BEST;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			
			onStageResize(null);
		}
		
		protected function draw():void {
			graphics.beginFill(background, 1);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
		}
		
		private function onStageResize(event:Event):void {
			unscaledWidth = stage.stageWidth;
			unscaledHeight = stage.stageHeight;
			draw();
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