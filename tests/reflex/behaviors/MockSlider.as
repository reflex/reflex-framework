package reflex.behaviors
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class MockSlider extends Sprite
	{
		
		[Bindable]
		public var thumb:Shape;
		
		[Bindable]
		public var track:Shape;
		
		[Bindable]
		public var incrementButton:Shape;
		
		[Bindable]
		public var decrementButton:Shape;
		
		public function MockSlider()
		{
			super();
			
			track = new Shape();
			track.graphics.beginFill(0x000000, 1);
			track.graphics.drawRect(0, 0, 100, 20);
			track.graphics.endFill();
			addChild(track);
			
			thumb = new Shape();
			thumb.graphics.beginFill(0xFFFFFF, 1);
			thumb.graphics.drawRect(0, 0, 10, 20);
			thumb.graphics.endFill();
			addChild(thumb);
			
			decrementButton = new Shape();
			decrementButton.graphics.beginFill(0xFFFFFF, 1);
			decrementButton.graphics.drawRect(0, 0, 20, 20);
			decrementButton.graphics.endFill();
			addChild(decrementButton);
			
			incrementButton = new Shape();
			incrementButton.graphics.beginFill(0xFFFFFF, 1);
			incrementButton.graphics.drawRect(0, 0, 20, 20);
			incrementButton.graphics.endFill();
			addChild(incrementButton);
			
		}
	}
}