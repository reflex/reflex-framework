package reflex.metadata
{
	
	// we'll have to consider the size impact of using these VOs later
	public class ClassDirectives
	{
		
		[ArrayElementType("reflex.metadata.Alias")]
		public var aliases:Array = [];
		
		[ArrayElementType("reflex.metadata.EventHandler")]
		public var eventHandlers:Array = [];
		
		[ArrayElementType("reflex.metadata.DefaultSetting")]
		public var defaultSettings:Array = [];
		
	}
}