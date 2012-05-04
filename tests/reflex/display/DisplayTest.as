package reflex.display {
	import flexunit.framework.Assert;
	
	import reflex.styles.StyleableMeasurableMeasurablePercentTestBase;

	public class DisplayTest extends StyleableMeasurableMeasurablePercentTestBase {
		public var item:MeasurableItem;
		
		public function DisplayTest() {
			super();
		}
		
		[Before]
		public function setup():void {
			item = new MeasurableItem();
		}
		
		[After]
		public function destroy():void {
			item = null;
		}

		[Test]
		public function testSetStyleWithSingleAssignment():void {
			item.style = "testProperty:testValue";
			
			Assert.assertTrue(item.style.hasOwnProperty("testProperty"));
			
			var testValue:String = item.style["testProperty"];
			
			Assert.assertEquals("testValue", testValue);
		}
		
		[Test]
		public function testSetStyleWithMultipleAssignments():void {
			item.style = "testProperty1:testValue1;testProperty2:testValue2";
			
			Assert.assertTrue(item.style.hasOwnProperty("testProperty1"));
			Assert.assertTrue(item.style.hasOwnProperty("testProperty2"));
			
			var testValue1:String = item.style["testProperty1"];
			var testValue2:String = item.style["testProperty2"];
			
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
				item.style = new Object();
			} catch (e:Error) {
				testPassed = true;
			}
			
			Assert.assertTrue("Trying to set the style with something other than a String should have caused an error.", testPassed);
		}
		
		[Test(async)]
		public function testXChange():void {
			testPropertyChange(MeasurableItem, "x", 100);
		}
		
		[Test(async)]
		public function testXNotChanged():void {
			testPropertyNotChanged(MeasurableItem, "x", 100);
		}
		
		[Test(async)]
		public function testyChange():void {
			testPropertyChange(MeasurableItem, "y", 100);
		}
		
		[Test(async)]
		public function testyNotChanged():void {
			testPropertyNotChanged(MeasurableItem, "y", 100);
		}
		
		[Test(async)]
		public function testVisibleChange():void {
			testPropertyChange(MeasurableItem, "visible", false);
		}
		
		[Test(async)]
		public function testVisibleNotChanged():void {
			testPropertyNotChanged(MeasurableItem, "visible", false);
		}
	}
}