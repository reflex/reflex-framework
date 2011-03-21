package reflex.display {
	import flexunit.framework.Assert;
	
	import reflex.styles.StyleableMeasurableMeasurablePercentTestBase;

	public class DisplayTest extends StyleableMeasurableMeasurablePercentTestBase {
		public var bitmapDisplay:BitmapDisplay;
		
		public function DisplayTest() {
			super();
		}
		
		[Before]
		public function setup():void {
			bitmapDisplay = new BitmapDisplay();
		}
		
		[After]
		public function destroy():void {
			bitmapDisplay = null;
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
		
		[Test(async)]
		public function testXChange():void {
			testPropertyChange(Display, "x", 100);
		}
		
		[Test(async)]
		public function testXNotChanged():void {
			testPropertyNotChanged(Display, "x", 100);
		}
		
		[Test(async)]
		public function testyChange():void {
			testPropertyChange(Display, "y", 100);
		}
		
		[Test(async)]
		public function testyNotChanged():void {
			testPropertyNotChanged(Display, "y", 100);
		}
		
		[Test(async)]
		public function testVisibleChange():void {
			testPropertyChange(Display, "visible", false);
		}
		
		[Test(async)]
		public function testVisibleNotChanged():void {
			testPropertyNotChanged(Display, "visible", false);
		}
	}
}