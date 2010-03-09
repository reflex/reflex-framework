package reflex.skins
{
	import flash.display.Graphics;
	import flash.display.GraphicsGradientFill;
	import flash.display.IGraphicsData;
	import flash.geom.Matrix;
	
	import flight.binding.Bind;
	import flight.events.PropertyEvent;
	
	import reflex.graphics.attributes.Angle;
	import reflex.graphics.attributes.Color;
	import reflex.graphics.attributes.CornerRadius;

	public class BackgroundSkin extends Skin
	{
		protected static var splitter:RegExp = /\s*,\s/;
		public var backgroundColors:String;
		public var backgroundAlphas:String;
		public var backgroundRatios:String;
		public var backgroundAngle:String;
		public var borderColors:String;
		public var borderAlphas:String;
		public var borderRatios:String;
		public var borderAngle:String;
		public var borderWidth:Number;
		public var radius:String;
		
		public function BackgroundSkin()
		{
			Bind.addListener(this, onPropChange, this, "target.width");
			Bind.addListener(this, onPropChange, this, "target.height");
		}
		
		protected function onPropChange():void
		{
			redraw();
		}
		
		protected function redraw():void
		{
			if (target == null) return;
			
			var g:Graphics = target.graphics;
			g.clear();
			var d:Vector.<IGraphicsData> = new Vector.<IGraphicsData>(1);
			var r:CornerRadius = CornerRadius.fromString(radius);
			
			var x:Number = 0;
			var y:Number = 0;
			var w:Number = target.width;
			var h:Number = target.height;
			
			var colors:Array;
			var alphas:Array;
			var ratios:Array;
			var angle:Number;
			var fill:GraphicsGradientFill;
			var m:Matrix = new Matrix();
			
			if (borderColors) {
				colors = getColors(borderColors);
				alphas = getAlphas(borderAlphas, colors.length);
				ratios = getRatios(borderRatios, colors.length);
				angle = Angle.fromString(borderAngle || "90");
				var bwidth:Number = borderWidth || 1;
				m.createGradientBox(w, h, angle, x, y);
				fill = new GraphicsGradientFill("linear", colors, alphas, ratios, m);
				d[0] = fill;
				g.drawGraphicsData(d);
				g.drawRoundRectComplex(x, y, w, h, r.topLeft, r.topRight, r.bottomLeft, r.bottomRight);
				x += bwidth;
				y += bwidth;
				w -= bwidth*2;
				h -= bwidth*2;
				r.inset(bwidth);
				g.drawRoundRectComplex(x, y, w, h, r.topLeft, r.topRight, r.bottomLeft, r.bottomRight);
				g.endFill();
			}
			
			if (backgroundColors) {
				colors = getColors(backgroundColors);
				alphas = getAlphas(backgroundAlphas, colors.length);
				ratios = getRatios(backgroundRatios, colors.length);
				angle = Angle.fromString(backgroundAngle || "90");
				m.createGradientBox(w, h, angle, x, y);
				fill = new GraphicsGradientFill("linear", colors, alphas, ratios, m);
				d[0] = fill;
				g.drawGraphicsData(d);
				g.drawRoundRectComplex(x, y, w, h, r.topLeft, r.topRight, r.bottomLeft, r.bottomRight);
			}
			
			r.dispose();
		}
		
		protected function getColors(colors:String):Array
		{
			return colors.split(splitter).map(toColor);
		}
		
		protected function getAlphas(alphas:String, count:int):Array
		{
			if (!alphas) alphas = "1";
			
			var result:Array = alphas.split(splitter).map(toAlpha);
			while (result.length < count) {
				result.push(result[0]);
			}
			result.length = count;
			return result;
		}
		
		protected function getRatios(ratios:String, count:int):Array
		{
			if (!ratios) ratios = "1";
			
			var result:Array = ratios.split(splitter).map(toRatio);
			
			// if we aren't accurate override
			if (result.length != count) {
				var stepSize:Number = 255/(count - 1);
				for (var i:int = 0; i < count; i++) {
					result[i] = i * stepSize;
				}
				result.length = count;
			}
			return result;
		}
		
		protected static function toColor(item:String, index:int, array:Array):uint
		{
			if (!item.length) return 0;
			return Color.fromString(item);
		}
		
		protected static function toAlpha(item:String, index:int, array:Array):Number
		{
			var alpha:Number = parseFloat(item);
			return isNaN(alpha) ? 1 : alpha;
		}
		
		protected static function toRatio(item:String, index:int, array:Array):Number
		{
			var percent:Number = parseFloat(item);
			return isNaN(percent) ? 255 : percent*255;
		}
	}
}