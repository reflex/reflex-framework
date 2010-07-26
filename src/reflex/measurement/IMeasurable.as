package reflex.measurement
{
	public interface IMeasurable
	{
		
		function get width():Number;
		function set width(value:Number):void;
		
		function get height():Number;
		function set height(value:Number):void;
		/*
		function get minWidth():Number;
		function set minWidth(value:Number):void;
		
		function get minHeight():Number;
		function set minHeight(value:Number):void;
		
		function get maxWidth():Number;
		function set maxWidth(value:Number):void;
		
		function get maxHeight():Number;
		function set maxHeight(value:Number):void;
		*/
		function get explicite():IMeasurements;
		function get measured():IMeasurements;
		
		function setSize(width:Number, height:Number):void;
		
	}
}