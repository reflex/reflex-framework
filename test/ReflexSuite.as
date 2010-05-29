package 
{
	import reflex.behaviors.CompositeBehaviorTest;
	import reflex.behaviors.SelectableBehaviorTest;
	import reflex.display.ContainerTest;
	import reflex.display.ReflexDisplayTest;

	//import reflex.utils.MetaInjectorTest;
	//import reflex.utils.MetaUtilTest;
	
	
	[Suite]
    [RunWith("org.flexunit.runners.Suite")]
	public class ReflexSuite
	{
		
		public var display:ReflexDisplayTest;
		public var container:ContainerTest;
		public var behaviors:CompositeBehaviorTest;
		public var selectabe:SelectableBehaviorTest;
		
	}
}