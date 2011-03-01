package reflex.skins
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import reflex.binding.DataChange;
	import reflex.metadata.resolveCommitProperties;
	
	public class GraphicSkin extends Skin
	{
		
		protected var graphics:Graphics;
		
		public function GraphicSkin()
		{
			super();
			//reflex.metadata.resolveCommitProperties(this);
			
		}
		
		override public function set target(value:Sprite):void {
			super.target = value;
			graphics = null;
			if(value) {
				graphics = value.graphics;
				value.addEventListener("layout", onRender, false, 0, true);
			}
		}
		
		override public function set currentState(value:String):void {
			super.currentState = value;
			render(value);
		}
		
		override public function hasState(state:String):Boolean
		{
			return true;
		}
		
		private function onRender(event:Event):void {
			render(currentState);
		}
		
		//[Commit(properties="width, height, currentState")]
		protected function render(currentState:String):void {
			
		}
		
	}
}