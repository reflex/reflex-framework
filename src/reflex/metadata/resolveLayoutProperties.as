package reflex.metadata
{
	import flash.events.IEventDispatcher;
	
	import flight.binding.Bind;
	import flight.utils.Type;
	
	// this method of listening for layout invalidating changes is very much experimental
	/**
	 * @experimental
	 */
	public function resolveLayoutProperties(instance:IEventDispatcher, child:IEventDispatcher, listener:Function):void
	{
		var desc:XML = Type.describeType(instance);
		for each (var meth:XML in desc.factory[0]) {
			var meta:XMLList = meth.metadata.(@name == "LayoutProperty");
			
			// to support multiple PropertyListener metadata tags on a single method
			for each (var tag:XML in meta) {
				var sourcePath:String = tag.arg.(@key == "name").@value;
				Bind.addListener(child, listener, child, sourcePath);
			}
			
		}
	}
	
}