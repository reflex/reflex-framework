package reflex.measurement
{
	public class Measurements
	{
		
		// todo: update for defined events
		
		[Bindable] public var minWidth:Number;
		[Bindable] public var minHeight:Number;
		
		[Bindable] public var maxWidth:Number;
		[Bindable] public var maxHeight:Number;
		
		[Bindable] public var expliciteWidth:Number;
		[Bindable] public var expliciteHeight:Number;
		
		//[Bindable] public var percentWidth:Number;
		//[Bindable] public var percentHeight:Number;
		
		[Bindable] public var measuredWidth:Number;
		[Bindable] public var measuredHeight:Number;
		
		public function Measurements(defaultWidth:Number = 160, defaultHeight:Number = 22) {
			measuredWidth = defaultWidth;
			measuredHeight = defaultHeight;
		}
		
	}
}