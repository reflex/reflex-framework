package reflex.data {
	import flexunit.framework.Assert;
	
	import mx.collections.ArrayCollection;

	public class PropertyValueDelimitersTest {
		private static var validStrings:ArrayCollection;
		private static var inValidStrings:ArrayCollection;

		public function PropertyValueDelimitersTest() {
		}
		
		[BeforeClass]
		public static function createTestStrings():void {
			createValidTestStrings();
			createInvalidTestStrings();
		}
		
		[AfterClass]
		public static function destroyTestStrings():void {
			validStrings = null;
			inValidStrings = null;
		}

		private static function createValidTestStrings():void {
			validStrings = new ArrayCollection();
			
			validStrings.addItem("abc:def");
			validStrings.addItem("abc:def;");
			validStrings.addItem("abc:def;ghi:jkl");
			validStrings.addItem("abc:def;ghi:jkl;");
			validStrings.addItem("abc:def;ghi:jkl;mnopqr:stuvwx");
			validStrings.addItem("abc:def;ghi:jkl;mnopqr:stuvwx;");
		}
		
		private static function createInvalidTestStrings():void {
			inValidStrings = new ArrayCollection();

			inValidStrings.addItem("");
			inValidStrings.addItem("abc:def:");
			inValidStrings.addItem("abc:def:;");
			inValidStrings.addItem("abc=def");
			inValidStrings.addItem("abc=def,ghi=jkl");
			inValidStrings.addItem(":abc");
			inValidStrings.addItem("abc:;def");
			inValidStrings.addItem("abc;:def");
			inValidStrings.addItem("abc:def;:");
		}
		
		[Test]
		public function testCheckPropertyValueDelimitersUsingValidString():void {
			for each (var testString:String in validStrings) {
				testValidTestString(testString);
			}
		}
		
		[Test]
		public function testCheckPropertyValueDelimitersUsingInvalidString():void {
			for each (var testString:String in inValidStrings) {
				testInvalidTestString(testString);
			}
		}
		
		private function testValidTestString(testString:String):void {
			var testPassed:Boolean = true;

			try {
				reflex.data.checkPropertyValueDelimiters(testString);
			} catch (e:Error) {
				testPassed = false;
			}

			Assert.assertTrue("Test Failed for Valid testString: " + testString, testPassed);
		}
		
		private function testInvalidTestString(testString:String):void {
			var testPassed:Boolean = false;
			
			try {
				reflex.data.checkPropertyValueDelimiters(testString);
			} catch (e:Error) {
				testPassed = true;
			}
			
			Assert.assertTrue("Test Failed for Invalid testString: " + testString, testPassed);
		}
	}
}