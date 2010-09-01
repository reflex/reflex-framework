package reflex.metadata
{
	import flash.events.IEventDispatcher;
	
	import reflex.binding.Bind;
	import reflex.events.PropertyEvent;
	import reflex.metadata.Type;
	
	import reflex.events.InvalidationEvent;
	
	/**
	 * @experimental
	 */
	public function resolveCommitProperties(instance:IEventDispatcher, resolver:Function = null):void
	{
		var desc:XMLList = Type.describeMethods(instance, "CommitProperties");
		for each (var meth:XML in desc) {
			var meta:XMLList = meth.metadata.(@name == "CommitProperties");
			
			// to support multiple CommitProperties metadata tags on a single method
			for each (var tag:XML in meta) {
				var target:String = ( tag.arg.(@key == "target").length() > 0 ) ? tag.arg.(@key == "target").@value : tag.arg.@value;
				var properties:Array = target.replace(/\s+/g, "").split(",");
				CommitUtility.instance.register(instance, meth.@name, properties, resolver);
			}
		}
	}
	
}