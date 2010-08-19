package 
{
	import flash.display.Stage;
	
	import reflex.behaviors.ButtonBehaviorTest;
	import reflex.behaviors.CompositeBehaviorTest;
	import reflex.behaviors.SelectableBehaviorTest;
	import reflex.components.ApplicationTest;
	import reflex.components.ButtonTest;
	import reflex.components.ComponentTest;
	import reflex.components.ListItemTest;
	import reflex.components.ListTest;
	import reflex.display.BindableSpriteTest;
	import reflex.display.ContainerTest;
	import reflex.display.DisplayFunctionsTest;
	import reflex.display.MeasuredSpriteTest;
	import reflex.display.StyleableSpriteTest;
	import reflex.measurement.MeasurementFunctionsTest;
	import reflex.skins.SkinContainerTest;
	import reflex.skins.SkinMeasurementTest;
	import reflex.styles.StyleFunctionsTest;
	
	[Suite]
    [RunWith("org.flexunit.runners.Suite")]
	public class ReflexSuite
	{
		
		//static public var stage:Stage;
		
		public var bindableSprite:BindableSpriteTest;
		public var measuredSprite:MeasuredSpriteTest;
		public var styleableSprite:StyleableSpriteTest;
		
		public var container:ContainerTest;
		
		public var compositeBehavior:CompositeBehaviorTest;
		public var selectabeBehavior:SelectableBehaviorTest;
		public var buttonBehavior:ButtonBehaviorTest;
		
		public var skinMeasurement:SkinMeasurementTest;
		public var skinContainer:SkinContainerTest;
		
		public var measurementFunctions:MeasurementFunctionsTest;
		public var styleFunctions:StyleFunctionsTest;
		public var displayFunctions:DisplayFunctionsTest;
		
		public var component:ComponentTest;
		//public var application:ApplicationTest;
		public var button:ButtonTest;
		public var listItem:ListItemTest;
		public var list:ListTest;
		
	}
}