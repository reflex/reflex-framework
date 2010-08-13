package 
{
	import reflex.behaviors.CompositeBehaviorTest;
	import reflex.behaviors.SelectableBehaviorTest;
	import reflex.display.ContainerTest;
	import reflex.display.MeasuredSpriteTest;
	import reflex.display.BindableSpriteTest;
	import reflex.skins.SkinMeasurementTest;
	
	[Suite]
    [RunWith("org.flexunit.runners.Suite")]
	public class ReflexSuite
	{
		
		public var display:BindableSpriteTest;
		
		public var container:ContainerTest;
		public var containerMeasurement:MeasuredSpriteTest;
		
		public var behaviors:CompositeBehaviorTest;
		public var selectabe:SelectableBehaviorTest;
		
		public var skinMeasurement:SkinMeasurementTest;
	}
}