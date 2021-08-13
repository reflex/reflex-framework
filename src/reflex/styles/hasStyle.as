package reflex.styles
{
	import reflex.framework.IStyleable;

	public function hasStyle(child:Object, property:String):Boolean
	{
		//if(child.hasOwnProperty("style") && child["style"] != null) {
			//return (child.style[property] != null);
		if(child is IStyleable) {
			var v:* = (child as IStyleable).getStyle(property);
			return v != null;
		} else {
			return false;
		}
	}
	
}