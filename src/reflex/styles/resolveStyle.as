package reflex.styles
{
	public function resolveStyle(child:Object, property:String, type:Object = null, standard:* = null):Object
	{
		if(child.hasOwnProperty("style") && child["style"] != null) {
			return child.style[property];
		} else {
			return standard;
		}
	}
	
}