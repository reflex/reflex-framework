package reflex.styles
{
	
	public function resolveStyle(child:Object, property:String, type:Object = null, standard:* = null):Object
	{
		//if(child.hasOwnProperty("style") && child["style"] != null) {
			//return child.style[property];
		if(child is IStyleable) {
			var v:* = (child as IStyleable).getStyle(property);
			return v != null ? v : standard;
		} else {
			return standard;
		}
	}
	
}