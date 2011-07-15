package reflex.graphics
{
	import flash.display.Graphics;
	
	public function resolveTargets(targets:Array):Vector.<Graphics> {
		var length:int = targets.length;
		var graphics:Vector.<Graphics> = new Vector.<Graphics>();
		for(var i:int = 0; i < length; i++) {
			var g:Graphics = resolveTarget(targets[i]);
			if(g != null) { graphics.push(g); }
		}
		return graphics;
	}
	
}