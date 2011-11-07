package 
{
	import flash.display.Stage;
	
	import mx.states.AddItemsTest;
	import mx.states.OverrideBaseTest;
	
	import reflex.behaviors.BehaviorTest;
	import reflex.behaviors.ButtonBehaviorTest;
	import reflex.behaviors.CompositeBehaviorTest;
	import reflex.behaviors.SelectBehaviorTest;
	import reflex.behaviors.SlideBehaviorTest;
	import reflex.behaviors.StepBehaviorTest;
	import reflex.collections.SimpleCollectionTest;
	import reflex.components.ButtonTest;
	import reflex.components.ComponentTest;
	import reflex.components.ListItemTest;
	import reflex.components.ListTest;
	import reflex.components.ScrollerDefinitionTest;
	import reflex.components.SliderDefinitionTest;
	import reflex.containers.ContainerLifecycleTest;
	import reflex.containers.ContainerMeasurementTest;
	import reflex.containers.ContainerTest;
	import reflex.data.PositionTest;
	import reflex.data.RangeTest;
	import reflex.data.ScrollPositionTest;
	import reflex.data.SelectionTest;
	import reflex.display.BitmapDisplayMeasurableTest;
	import reflex.display.DisplayFunctionsTest;
	import reflex.display.DisplayMeasurableTest;
	import reflex.display.DisplayStyleableTest;
	import reflex.display.DisplayTest;
	import reflex.display.GroupTest;
	import reflex.display.TextFieldDisplayMeasurableTest;
	import reflex.graphics.GraphicBaseMeasurementTest;
	import reflex.layouts.BasicLayoutTest;
	import reflex.layouts.HorizontalLayoutTest;
	import reflex.layouts.VerticalLayoutTest;
	import reflex.layouts.XYLayoutTest;
	import reflex.measurement.MeasurementFunctionsTest;
	import reflex.skins.SkinContainerTest;
	import reflex.skins.SkinMeasurementTest;
	import reflex.styles.StyleFunctionsTest;
	import reflex.templating.addItemAtTest;
	import reflex.text.LabelTest;
	
	[Suite]
    [RunWith("org.flexunit.runners.Suite")]
	public class ReflexSuite
	{
		
		static public var stage:Stage;
		
		// components
		public var component:ComponentTest;
		//public var application:ApplicationTest;
		public var button:ButtonTest;
		public var listItem:ListItemTest;
		public var list:ListTest;
		public var scrollerDefinition:ScrollerDefinitionTest;
		public var sliderDefinition:SliderDefinitionTest;
		
		// behaviors
		public var behavior:BehaviorTest;
		public var compositeBehavior:CompositeBehaviorTest;
		public var buttonBehavior:ButtonBehaviorTest;
		public var selectabeBehavior:SelectBehaviorTest;
		//public var slideBehavior:SlideBehaviorTest;
		public var stepBehavior:StepBehaviorTest;
		
		// containers
		public var container:GroupTest;
		public var skinContainer:SkinContainerTest;
		public var displayFunctions:DisplayFunctionsTest;
		public var containerMeasurement:ContainerMeasurementTest;
		public var containerTest:ContainerTest;

		// data
		public var position:PositionTest;
		public var range:RangeTest;
		public var scrollPosition:ScrollPositionTest;
		public var selection:SelectionTest;

		// display
		public var display:DisplayTest;

		// styling
		public var styleableSprite:DisplayStyleableTest;
		public var styleFunctions:StyleFunctionsTest;
		
		// measurement
		public var measurementFunctions:MeasurementFunctionsTest;
		public var skinMeasurement:SkinMeasurementTest;
		public var measuredBitmap:BitmapDisplayMeasurableTest;
		public var measuredTextField:TextFieldDisplayMeasurableTest;
		public var measuredSprite:DisplayMeasurableTest;
		
		// layouts
		public var xyLayout:XYLayoutTest;
		public var basicLayout:BasicLayoutTest;
		public var verticalLayout:VerticalLayoutTest;
		public var horizontalLayout:HorizontalLayoutTest;
		
		// collections
		public var collection:SimpleCollectionTest;
		
		//templating
		public var addItemAt:addItemAtTest;
		
		// states
		public var addItems:AddItemsTest;
		//public var overrideBase:OverrideBaseTest; // no tests yet
		
		//graphics
		public var graphicMeasurement:GraphicBaseMeasurementTest;
		
		//text
		public var label:LabelTest;
		
		//lifecycle
		public var containerLifecycle:ContainerLifecycleTest;
		
	}
}