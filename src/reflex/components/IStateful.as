package reflex.components
{
	
	/**
	 * @alpha
	 */
	public interface IStateful
	{
		function get states():Array;
		function set states(value:Array):void;
		
		function get transitions():Array;
		function set transitions(value:Array):void;
		
		function get currentState():String;
		function set currentState(value:String):void;
		
		function hasState(state:String):Boolean;
		
	}
}