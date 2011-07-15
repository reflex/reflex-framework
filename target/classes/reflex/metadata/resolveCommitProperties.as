package reflex.metadata
{
	import flash.events.IEventDispatcher;
	
	/**
	 * @experimental
	 */
	// this needs some updates to handle non-DisplayObjects (like Rect) better
	public function resolveCommitProperties(instance:IEventDispatcher, resolver:Function = null):void
	{
		var desc:XMLList = Type.describeMethods(instance, "Commit");
		for each (var meth:XML in desc) {
			var meta:XMLList = meth.metadata.(@name == "Commit");
			
			// to support multiple CommitProperties metadata tags on a single method
			for each (var tag:XML in meta) {
				var target:String = ( tag.arg.(@key == "properties").length() > 0 ) ? tag.arg.(@key == "properties").@value : tag.arg.@value;
				var properties:Array = target.replace(/\s+/g, "").split(",");
				CommitUtility.instance.register(instance, meth.@name, properties, resolver);
			}
		}
	}
	
}