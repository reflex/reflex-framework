package reflex.metadata
{
	import flash.events.IEventDispatcher;
	
	import flight.binding.Bind;
	import flight.utils.Type;
	
	/**
	 * @experimental
	 */
	public function resolveEventListeners(instance:IEventDispatcher):void
	{
		var desc:XMLList = Type.describeMethods(instance, "EventListener");
		for each (var meth:XML in desc) {
			var meta:XMLList = meth.metadata.(@name == "EventListener");
			
			// to support multiple EventListener metadata tags on a single method
			for each (var tag:XML in meta) {
				var type:String = ( tag.arg.(@key == "type").length() > 0 ) ?
					tag.arg.(@key == "type").@value :
					tag.arg.@value;
				var targ:String = tag.arg.(@key == "target").@value;
				
				Bind.bindEventListener(type, instance[meth.@name], instance, targ);
			}
		}
		
	}
	
}