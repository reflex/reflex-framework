package reflex.metadata
{
	import flash.events.IEventDispatcher;
	
	import flight.binding.Bind;
	import flight.utils.Type;
	
	/**
	 * @experimental
	 */
	public function resolveBindings(instance:IEventDispatcher):void
	{
		var desc:XMLList = Type.describeProperties(instance, "Binding");
		for each (var prop:XML in desc) {
			var meta:XMLList = prop.metadata.(@name == "Binding");
			
			// to support multiple Binding metadata tags on a single property
			for each (var tag:XML in meta) {
				var targ:String = ( tag.arg.(@key == "target").length() > 0 ) ?
					tag.arg.(@key == "target").@value :
					tag.arg.@value;
				
				Bind.addBinding(instance, targ, instance, prop.@name, true);
			}
		}
	}
	
}