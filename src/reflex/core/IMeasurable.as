package reflex.core
{
	public interface IMeasurable
	{
		
		function get explicitWidth():Number;
		function set explicitWidth(value:Number):void;
		
		function get explicitHeight():Number;
		function set explicitHeight(value:Number):void;
		
		function get measuredWidth():Number;
		function set measuredWidth(value:Number):void;
		
		function get measuredHeight():Number;
		function set measuredHeight(value:Number):void;
		
		//function setActualSize(width:Number, height:Number):void;
		
	}
}