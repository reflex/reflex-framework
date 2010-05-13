package reflex.styles
{
	public function hasStyle(child:Object, property:String):Boolean
	{
		if(child.hasOwnProperty("style") && child["style"] != null) {
			return (child.style[property] != null);
		} else {
			return false;
		}
	}
	
}