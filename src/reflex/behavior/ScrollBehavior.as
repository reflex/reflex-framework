package reflex.behavior
{
	import flash.display.InteractiveObject;
	
	import flight.position.IPosition;

	public class ScrollBehavior extends Behavior
	{
		public var position:IPosition;
		
//		[SkinPart]
		public var fwdBtn:InteractiveObject;
		
//		[SkinPart]
		public var bwdBtn:InteractiveObject;
		
//		[SkinPart]
		public var track:InteractiveObject;
		
		public function ScrollBehavior()
		{
		}
		
	}
}