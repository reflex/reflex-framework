package mx.core
{
	import flash.events.IEventDispatcher;
	
	public interface IStateClient2 extends IEventDispatcher, IStateClient
	{
		
		[ArrayElementType("mx.states.State")]
		function get states():Array;
		
		/**
		 *  @private
		 */
		function set states(value:Array):void;
		
		
		//----------------------------------
		//  transitions
		//----------------------------------
		
		[ArrayElementType("mx.states.Transition")]
		function get transitions():Array;
		
		/**
		 *  @private
		 */
		function set transitions(value:Array):void;
		
		function hasState(stateName:String):Boolean
	}
}