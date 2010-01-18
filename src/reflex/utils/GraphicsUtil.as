package reflex.utils
{
	import __AS3__.vec.Vector;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class GraphicsUtil
	{
		
		static public function resolveGraphics(target:Object):Vector.<Graphics> {
			if(target is Array) {
				return resolveTargets(target as Array);
			} else {
				var g:Graphics = resolveTarget(target);
				if(g != null) {
					var v:Vector.<Graphics> = new Vector.<Graphics>();
					v[0] = g;
					return v;
				} else {
					return null;
				}
			}
		}
		
		static public function resolveTarget(target:Object):Graphics {
			if(target is Sprite) {
				return (target as Sprite).graphics;
			} else if(target is Shape) {
				return (target as Shape).graphics;
			} else if(target is Graphics) {
				return target as Graphics;
			} else {
				return null;
			}
		}
		
		static public function resolveTargets(targets:Array):Vector.<Graphics> {
			var length:int = targets.length;
			var graphics:Vector.<Graphics> = new Vector.<Graphics>();
			for(var i:int = 0; i < length; i++) {
				var g:Graphics = resolveTarget(targets[i]);
				if(g != null) { graphics.push(g); }
			}
			return graphics;
		}
		
	}
}