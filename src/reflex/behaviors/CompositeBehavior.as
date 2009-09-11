package reflex.behaviors
{
	import reflex.core.IBehavior;

	public class CompositeBehavior implements IBehavior
	{
		
		[Bindable] public var owner:Object;
		
		[Bindable] public var behaviors:Array;
		
		
	}
}