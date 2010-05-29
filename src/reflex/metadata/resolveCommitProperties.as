package reflex.metadata
{
	import flash.events.IEventDispatcher;
	
	import flight.binding.Bind;
	import flight.utils.Type;
	
	/**
	 * @experimental
	 */
	public function resolveCommitProperties(instance:IEventDispatcher):void
	{
		var desc:XMLList = Type.describeMethods(instance, "CommitProperties");
		for each (var meth:XML in desc) {
			var meta:XMLList = meth.metadata.(@name == "CommitProperties");
			
			// to support multiple PropertyListener metadata tags on a single method
			for each (var tag:XML in meta) {
				var targ:String = ( tag.arg.(@key == "target").length() > 0 ) ?
					tag.arg.(@key == "target").@value :
					tag.arg.@value;
				
				Bind.addListener(instance, instance[meth.@name], instance, targ);
			}
		}
	}
}