package reflex.metadata
{
	import flash.events.IEventDispatcher;
	
	import reflex.binding.Bind;
	
	/**
	 * @experimental
	 */
	public function resolveDataListeners(instance:IEventDispatcher):void
	{
		var desc:XMLList = Type.describeMethods(instance, "DataListener");
		for each (var meth:XML in desc) {
			var meta:XMLList = meth.metadata.(@name == "DataListener");
			
			// to support multiple DataListener metadata tags on a single method
			for each (var tag:XML in meta) {
				var targ:String = ( tag.arg.(@key == "target").length() > 0 ) ?
					tag.arg.(@key == "target").@value :
					tag.arg.@value;
				
				Bind.addListener(instance, instance[meth.@name], instance, targ);
			}
		}
	}
	
}