package reflex.graphics.attributes
{
	/**
	 * @private
	 * Utility class that helps transform between degrees and radians. The
	 * default angle is radians.
	 */
	public class Angle
	{
		/**
		 * Takes a string value of an angle (e.g. deg(90)) and converts it into
		 * radians.
		 */
		public static function fromString(angle:String):Number
		{
			var parts:Array = angle.match(/(\d*.?\d+)(\w*)/);
			var value:Number = parseFloat(parts[1]);
			if (isNaN(value)) {
				return 0;
			}
			var unit:String = parts[2] || "deg";
			if (unit == "deg") {
				value = fromDegrees(value);
			} else if (unit == "grad") {
				value = fromGrads(value);
			} else if (unit != "rad") {
				return 0; // syntax error
			}
			
			return value;
		}
		
		
		/**
		 * Converts grads to radians, for use with Transform rotations.
		 */
		public static function fromGrads(grads:Number):Number
		{
			return grads * Math.PI/200;
		}
		
		
		/**
		 * Converts degrees to radians, for use with Transform rotations.
		 */
		public static function fromDegrees(degrees:Number):Number
		{
			return degrees * Math.PI/180;
		}
		
		/**
		 * Converts radians to degrees, for use with Transform rotations.
		 */
		public static function toDegree(radians:Number):Number
		{
			return radians * 180/Math.PI;
		}
		
		
	}
}