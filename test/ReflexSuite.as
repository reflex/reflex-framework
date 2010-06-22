package 
{
	import reflex.behaviors.CompositeBehaviorTest;
	import reflex.behaviors.SelectableBehaviorTest;
	import reflex.display.ContainerTest;
	import reflex.display.ReflexDisplayMeasurementTest;
	import reflex.display.ReflexDisplayTest;
	import reflex.skins.SkinMeasurementTest;
	
	[Suite]
    [RunWith("org.flexunit.runners.Suite")]
	public class ReflexSuite
	{
		
		public var display:ReflexDisplayTest;
		
		public var container:ContainerTest;
		public var containerMeasurement:ReflexDisplayMeasurementTest;
		
		public var behaviors:CompositeBehaviorTest;
		public var selectabe:SelectableBehaviorTest;
		
		public var skinMeasurement:SkinMeasurementTest;
	}
}