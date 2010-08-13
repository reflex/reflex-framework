package reflex.display
{
	import flash.display.Sprite;
	
	import flight.events.PropertyEvent;
	
	/**
	 * The BindableSprite class makes most DisplayObject properties bindable.
	 * 
	 * 
	 */
	public class BindableSprite extends Sprite
	{
		
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
		override public function get width():Number { return super.width; }
		override public function set width(value:Number):void {
			if (super.width == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "width", super.width, super.width = value);
		}
		
		[Bindable(event="heightChange")]
		override public function get height():Number { return super.height; }
		override public function set height(value:Number):void {
			if (super.height == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "height", super.height, super.height = value);
		}
		
		
	}
}