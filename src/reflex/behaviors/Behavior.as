package reflex.behaviors
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import reflex.core.IBehavior;
	
	/**
	 * A base behavior class. Provides functionality for setting up listeners
	 * automatically with metadata.
	 */
	public class Behavior extends EventDispatcher implements IBehavior
	{
		protected var _name:String;
		protected var _target:Object;
		
		/**
		 * Constructor. Set the default name of this behavior here so that it
		 * can be change outside the behavior by others.
		 */
		public function Behavior()
		{
			_name = "";
		}
		
		
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
		
		
		[Bindable("nameChange")]
		/**
		 * The property lookup name this behavior will use when set in a
		 * behavior map as an array.
		 */
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			if (value == _name) return;
			_name = value;
			dispatch("nameChange");
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