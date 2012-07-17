package mx.core
{
	public interface IStateClient
	{
		function get currentState():String;
		
		/**
		 *  @private
		 */
		function set currentState(value:String):void;
	}
}