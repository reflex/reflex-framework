package reflex.behaviors
{
	
	import flash.events.EventDispatcher;
	
	/**
	 * A base behavior class. Provides functionality for setting up listeners
	 * automatically with metadata.
	 */
	public class Behavior extends EventDispatcher
	{
		
		protected namespace reflex = "http://reflex.io";
		
		private var _target:Object;
		
		/**
		 * The object this behavior acts upon.
		 */
		public function get target():Object
		{
			return _target;
		}
		
		public function set target(value:Object):void
		{
			if (value == _target) return;
			_target = value;
		}
	}
}