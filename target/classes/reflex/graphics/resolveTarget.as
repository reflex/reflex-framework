package reflex.graphics
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public function resolveTarget(target:Object):Graphics {
		if(target is Sprite) {
			return (target as Sprite).graphics;
		} else if(target is Shape) {
			return (target as Shape).graphics;
		} else if(target is Graphics) {
			return target as Graphics;
		} else {
			return target != null ? target.graphics : null;
		}
	}
	
}