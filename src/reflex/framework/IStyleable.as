package reflex.framework
{
	
	public interface IStyleable
	{
		
		function get id():String;
		function set id(value:String):void;
		
		function get styleName():String;
		function set styleName(value:String):void;
		/*
		function get style():Object;
		function set style(value:Object):void;
		*/
		
		function getStyle(property:String):*;
		function setStyle(property:String, value:*):void; // the mxmlc compiler looks or this method specifically (no interface is required)
		
	}
	
}
