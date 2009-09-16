package reflex.styles
{
	
	public interface IStylable
	{
		function get id():String;
		function set id(value:String):void;
		
		function get styleName():String;
		function set styleName(value:String):void;
		
		function get state():String;
		function set state(value:String):void;
	}
	
}
