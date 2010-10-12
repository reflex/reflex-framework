package reflex.skins
{
	import flash.display.MovieClip;
	
	import reflex.binding.DataChange;
	
	public class MovieClipSkin extends MovieClip
	{
		
		protected var unscaledWidth:Number = 160;
		protected var unscaledHeight:Number = 22;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="widthChange")]
		override public function get width():Number { return unscaledWidth; }
		override public function set width(value:Number):void {
			DataChange.change(this, "width", unscaledWidth, unscaledWidth = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="heightChange")]
		override public function get height():Number { return unscaledHeight; }
		override public function set height(value:Number):void {
			DataChange.change(this, "height", unscaledHeight, unscaledHeight = value);
		}
		
	}
}