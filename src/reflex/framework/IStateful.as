package reflex.framework
{
	import mx.core.IStateClient2;
	
	/**
	 * @alpha
	 */
	public interface IStateful extends IStateClient2
	{
		
		// these are all expected by the MXMLC compiler
		// even transitions, yeah I know
		/*
		function get states():Array;
		function set states(value:Array):void;
		
		function get transitions():Array;
		function set transitions(value:Array):void;
		
		function get currentState():String;
		function set currentState(value:String):void;
		
		function hasState(state:String):Boolean;
		*/
	}
}