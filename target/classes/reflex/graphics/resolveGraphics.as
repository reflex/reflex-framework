package reflex.graphics
{
	import flash.display.Graphics;
	
	public function resolveGraphics(target:Object):Vector.<Graphics>
	{
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
	
}