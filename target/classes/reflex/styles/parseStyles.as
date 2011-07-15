package reflex.styles
{
	public function parseStyles(style:Object, token:String):void
	{
		var assignments:Array = token.split(";");
		for each(var assignment:String in assignments) {
			var split:Array = assignment.split(":");
			if (split.length == 2) {
				var property:String = split[0].replace(/\s+/g, "");
				var v:String = split[1].replace(/\s+/g, "");
				if(!isNaN( Number(v) )) {
					style[property] = Number(v);
				} else {
					style[property] = v;
				}
			}
		}
	}
	
}