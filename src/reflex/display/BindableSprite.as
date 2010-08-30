package reflex.display
{
	import flash.display.Sprite;
	
	import flight.events.PropertyEvent;
	
	/**
	 * The BindableSprite class makes most DisplayObject properties bindable.
	 * 
	 * @alpha
	 */
	public class BindableSprite extends Sprite
	{
		
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		// which properties become bindable are up for debate
		// should it really be all of them? size concerns?
		
		// should x/y even be bindable?
		[Bindable(event="xChange")]
		override public function get x():Number { return super.x; }
		override public function set x(value:Number):void {
			if (super.x == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "x", super.x, super.x = value);
		}
		
		[Bindable(event="yChange")]
		override public function get y():Number { return super.y; }
		override public function set y(value:Number):void {
			if (super.y == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "y", super.y, super.y = value);
		}
		
		
		// should width/height even be bindable?
		[Bindable(event="widthChange")]
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void {
			if (_width == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "width", _width, _width = value);
		}
		
		[Bindable(event="heightChange")]
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void {
			if (_height == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "height", _height, _height = value);
		}
		
		
	}
}