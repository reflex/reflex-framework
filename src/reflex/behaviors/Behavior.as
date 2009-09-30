package reflex.behaviors
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import reflex.core.IBehavior;
	
	/**
	 * A base behavior class. Provides functionality for setting up listeners
	 * automatically with metadata.
	 */
	public class Behavior extends EventDispatcher
	{
		
		private var _target:Object;
		
		[Bindable("targetChange")]
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
			dispatch("targetChange");
		}
		
		
		////// Other base behavior methods which handle metadata etc. //////////
		
		
		/**
		 * Easier event dispatching with better performance if no one is
		 * listening.
		 */
		public function dispatch(type:String):Boolean
		{
			if (hasEventListener(type)) {
				return super.dispatchEvent( new Event(type) );
			}
			return false;
		}
	}
}