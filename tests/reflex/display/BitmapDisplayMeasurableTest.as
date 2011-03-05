package reflex.display
{
	import flexunit.framework.Assert;
	
	import reflex.measurement.MeasurableTestBase;
	
	public class BitmapDisplayMeasurableTest extends MeasurableTestBase
	{
		public var bitmapDisplay:BitmapDisplay;

		public function BitmapDisplayMeasurableTest()
		{
			super();
			C = BitmapDisplay;
		}
		
		[Before]
		public function setup():void {
			bitmapDisplay = new BitmapDisplay();
		}
		
		[After]
		public function destroy():void {
			bitmapDisplay = null;
		}

		[Test(async)]
		public function testIdChange():void {
			testPropertyChange(C, "id", "testId");
		}
		
		[Test(async)]
		public function testIdNotChanged():void {
			testPropertyNotChanged(C, "id", "testId");
		}
		
		[Test(async)]
		public function testStyleNameChange():void {
			testPropertyChange(C, "styleName", "testStyleName");
		}
		
		[Test(async)]
		public function testStyleNameNotChanged():void {
			testPropertyNotChanged(C, "styleName", "testStyleName");
		}
		
		[Test]
		public function testSetStyleWithSingleAssignment():void {
			bitmapDisplay.style = "testProperty:testValue";

			Assert.assertTrue(bitmapDisplay.style.hasOwnProperty("testProperty"));

			var testValue:String = bitmapDisplay.style["testProperty"];

			Assert.assertEquals("testValue", testValue);
		}
		
		[Test]
		public function testSetStyleWithMultipleAssignments():void {
			bitmapDisplay.style = "testProperty1:testValue1;testProperty2:testValue2";
			
			Assert.assertTrue(bitmapDisplay.style.hasOwnProperty("testProperty1"));
			Assert.assertTrue(bitmapDisplay.style.hasOwnProperty("testProperty2"));
			
			var testValue1:String = bitmapDisplay.style["testProperty1"];
			var testValue2:String = bitmapDisplay.style["testProperty2"];
			
			Assert.assertEquals("testValue1", testValue1);
			Assert.assertEquals("testValue2", testValue2);
		}
		
		/*
		[Test] [Ignore]
		public function testSetStyleWithIncorrectDelimiterUsage():void {
			var testPassed:Boolean = false;

			try {
				bitmapDisplay.style = "testProperty1=testValue1,testProperty2=testValue2";
			} catch (e:Error) {
				testPassed = true;
			}

			Assert.assertTrue("Trying to set the style when using delimiters other than \":\" and \";\" should have caused an error.", testPassed);
		}
		*/
		
		[Test]
		public function testSetStyleWithNonStringAssignment():void {
			var testPassed:Boolean = false;
			
			try {
				bitmapDisplay.style = new Object();
			} catch (e:Error) {
				testPassed = true;
			}
			
			Assert.assertTrue("Trying to set the style with something other than a String should have caused an error.", testPassed);
		}
		
		[Test]
		public function testDirectStylePropertyAssignment():void {
			bitmapDisplay.setStyle("testProperty", "testValue");

			var resultingValue:String = bitmapDisplay.getStyle("testProperty");

			Assert.assertEquals("testValue", resultingValue);
		}
		
		[Test(async)]
		public function testXChange():void {
			testPropertyChange(C, "x", 100);
		}
		
		[Test(async)]
		public function testXNotChanged():void {
			testPropertyNotChanged(C, "x", 100);
		}
		
		[Test(async)]
		public function testyChange():void {
			testPropertyChange(C, "y", 100);
		}
		
		[Test(async)]
		public function testyNotChanged():void {
			testPropertyNotChanged(C, "y", 100);
		}
		
		[Test(async)]
		public function testPercentWidthChange():void {
			testPropertyChange(C, "percentWidth", 100);
		}
		
		[Test(async)]
		public function testPercentWidthNotChanged():void {
			testPropertyNotChanged(C, "percentWidth", 100);
		}
		
		[Test(async)]
		public function testPercentHeightChange():void {
			testPropertyChange(C, "percentHeight", 100);
		}
		
		[Test(async)]
		public function testPercentHeightNotChanged():void {
			testPropertyNotChanged(C, "percentHeight", 100);
		}
		
		[Test(async)]
		public function testVisibleChange():void {
			testPropertyChange(C, "visible", false);
		}
		
		[Test(async)]
		public function testVisibleNotChanged():void {
			testPropertyNotChanged(C, "visible", false);
		}
	}
}