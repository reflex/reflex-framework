package reflex.display
{
	
	import flash.events.Event;
	import flash.text.TextLineMetrics;
	
	import reflex.events.PropertyEvent;
	
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
		
		/**
		 * @private
		 */
		[CommitProperties(target="text")]
		public function measure(event:Event):void {
			var metrics:TextLineMetrics = this.getLineMetrics(0);
			measured.width = metrics.width;
			measured.height = 12;
		}
		
	}
}