package reflex.text
{
	
	import flash.events.Event;
	import flash.text.TextFieldType;
	import flash.text.TextLineMetrics;
	
	import reflex.metadata.resolveCommitProperties;
	
	[Style(name="left")]
	[Style(name="right")]
	[Style(name="top")]
	[Style(name="bottom")]
	[Style(name="horizontalCenter")]
	[Style(name="verticalCenter")]
	[Style(name="dock")]
	[Style(name="align")]
	
	public class Text extends TextFieldDisplay
	{
		public function Text()
		{
			super();
			this.selectable = false;
			reflex.metadata.resolveCommitProperties(this);
		}
		
	}
}