package reflex.core
{
	public interface IMeasurableRange
	{
		
		function get minWidth():Number;
		function set minWidth(value:Number):void;
		
		function get maxWidth():Number;
		function set maxWidth(value:Number):void;
		
		function get minHeight():Number;
		function set minHeight(value:Number):void;
		
		function get maxHeight():Number;
		function set maxHeight(value:Number):void;
		
		function get measuredMinWidth():Number;
		function set measuredMinWidth(value:Number):void;
		
		function get measuredMinHeight():Number;
		function set measuredMinHeight(value:Number):void;
		
	}
}