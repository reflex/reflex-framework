package reflex.behaviors
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import reflex.core.IBehavior;

	use namespace flash_proxy;
	
	/**
	 * A dynamic holder for behaviors. This object will store behaviors for a
	 * target for access at runtime. Setting a behavior on the behaviorMap will
	 * set the target of that behavior for initialization. The map may be
	 * iterated through just as a regular object might.
	 */
	public dynamic class BehaviorMap extends Proxy implements IEventDispatcher
	{
		/**
		 * The object the behaviors will target.
		 */
		protected var _target:Object;
		
		/**
		 * A dispatcher for event dispatching. Events are dispatched for binding.
		 */
		protected var dispatcher:EventDispatcher;
		
		/**
		 * The behaviors stored in this map.
		 */
		protected var behaviors:Object = {};
		
		
		/**
		 * Constructor.
		 * 
		 * @param The target for this behavior map.
		 */
		public function BehaviorMap(target:Object = null)
		{
			_target = target;
		}
		
		
		[Bindable("targetChange")]
		/**
		 * The object which the behaviors in this map will act upon.
		 */
		public function get target():Object
		{
			return _target;
		}
		
		public function set target(value:Object):void
		{
			if (value == _target) return;
			_target = value;
			for each (var behavior:IBehavior in behaviors) {
				behavior.target = value;
			}
			dispatch("targetChange");
		}
		
		
		[ArrayElementType("reflex.core.IBehavior")]
		/**
		 * A method for adding an array of behaviors all at once. The name on
		 * each behavior will be what is used as the property name.
		 * 
		 * @param An array of behavior objects.
		 */
		public function add(behaviors:Array):void
		{
			for each (var behavior:IBehavior in behaviors) {
				this[behavior.name] = behavior;
			}
		}
		
		
		/**
		 * Proxy method to return a requested property.
		 */
		override flash_proxy function getProperty(name:*):*
		{
			return behaviors[name];
		}
		
		
		/**
		 * Proxy method to set a property. Accepts a Class object for an
		 * IBehavior or an IBehavior object itself.
		 */
		override flash_proxy function setProperty(name:*, value:*):void
		{
			var oldBehavior:IBehavior = behaviors[name] as IBehavior;
			if (value is Class) { // allow classes to be used to set behaviors
				if (oldBehavior is value) return;
				value = new value();
			}
			
			if (value == oldBehavior) return;
			if (value == null) {
				deleteProperty(name);
				return;
			}
			
			if (value != null && !(value is IBehavior) ) {
				throw new ArgumentError("Only IBehavior objects can be added to behaviors.");
			}
			
			if (oldBehavior) {
				oldBehavior.target = null;
			}
			
			var behavior:IBehavior = value as IBehavior;
			
			if (behavior) {
				behavior.target = target;
			}
			behaviors[name] = behavior;
			dispatch(name + "Change");
		}
		
		
		/**
		 * Proxy method to delete the specified property.
		 */
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			var behavior:IBehavior = behaviors[name] as IBehavior;
			if (behavior) {
				behavior.target = null;
			}
			return delete behaviors[name];
		}
		
		
		/**
		 * Proxy method to check if the specified property exists.
		 */
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return (name in behaviors);
		}
		
		
		/**
		 * Proxy method to call a method. If a behavior is set on the map and
		 * has an <code>execute</code> method then this may be called as a
		 * shortcut on the behavior map.
		 * 
		 * Example:
		 * 
		 * A SelectBehavior has an <code>execute</code> method which calls the behavior's
		 * <code>select()</code> method. Instead of calling <code>map.select.select()</code>
		 * you may call <code>map.select()</code>. Even though select is the
		 * IBehavior, calling it as a function on the behavior map will trigger
		 * its <code>execute</code> method.
		 */
		override flash_proxy function callProperty(name:*, ...rest):*
		{
			if (name in behaviors && "execute" in behaviors[name]) {
				return behaviors[name].execute.apply(null, rest);
			}
		}
		
		
		private var props:Array;
		
		/**
		 * Proxy method allowing looping through the map.
		 */
		override flash_proxy function nextName(index:int):String
		{
			if (index == 0) {
				props = [];
				for (var i:String in behaviors) {
					props.push(i);
				}
			}
			return props[index - 1];
		}
		
		/**
		 * Proxy method allowing looping through the map.
		 */
		override flash_proxy function nextValue(index:int):*
		{
			return behaviors[props[index - 1]];
		}
		
		/**
		 * Proxy method allowing looping through the map.
		 */
		override flash_proxy function nextNameIndex(index:int):int
		{
			return (index + 1) % (props.length + 1); // returns 0 when it hits length
		}
		
		
		
		// ========== Dispatcher Methods ========== //
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if (dispatcher == null) {
				dispatcher = new EventDispatcher(this);
			}
			
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			if (dispatcher != null) {
				dispatcher.removeEventListener(type, listener, useCapture);
			}
		}
		
		
		public function dispatchEvent(event:Event):Boolean
		{
			if (dispatcher != null && dispatcher.hasEventListener(event.type)) {
				return dispatcher.dispatchEvent(event);
			}
			return false;
		}
		
		
		public function hasEventListener(type:String):Boolean
		{
			if (dispatcher != null) {
				return dispatcher.hasEventListener(type);
			}
			return false;
		}
		
		
		public function willTrigger(type:String):Boolean
		{
			if (dispatcher != null) {
				return dispatcher.willTrigger(type);
			}
			return false;
		}
		
		
		protected function dispatch(type:String):Boolean
		{
			if (dispatcher != null && dispatcher.hasEventListener(type)) {
				return dispatcher.dispatchEvent( new Event(type) );
			}
			return false;
		}
	}
}