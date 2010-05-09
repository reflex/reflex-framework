package reflex.graphics.attributes
{
	
	/**
	 * @private
	 **/
	public class Length
	{
		
		private static var regex1:RegExp = /^(-?[\d.]+)(px)?$/;
		private static var regex2:RegExp = /^(-?[\d.]+)(in|cm|mm|pt)$/;
		private static var dpi:Number = 72
		
		
		/**
		 * Takes a length value (e.g. x, y, width, height) and returns the pixel
		 * value. Does NOT support % or "em" lengths
		 */
		public static function fromString(value:String):Number
		{
			// strip any whitespace
			value = value.replace(/\s/g, "");
			
			if (value == '') {
				return 0;
			}
			
			var matches:Array;
			
			if ( (matches = value.match(regex1)) ) {
				return Number(matches[1]);
			} else if ( (matches = value.match(regex2)) ) {
				if (matches[2] == "in") {
					return Number(matches[1])*dpi;					// 1 inch in dpi pixels
				} else if (matches[2] == "cm") {
					return Number(matches[1])*dpi/2.54;				// 2.54 cm in 1 inch
				} else if (matches[2] == "mm") {
					return Number(matches[1])*dpi/2.54/10;			// 10 mm in 1 cm or 0.254 mm in 1 inch
				} else if (matches[2] == "pt") {
					return Number(matches[1]);						// 72 points in 1 inch
				} else if (matches[2] == "pc") {
					return Number(matches[1])*12;					// 1 pica in 12 points
				}
			}
			
			return 0;
		}
		
		
		/**
		 * Converts a number into a length string.
		 * 
		 * @return The length string.
		 */
		public static function toString(value:Number):String
		{
			return value + "px";
		}
		
	}
}