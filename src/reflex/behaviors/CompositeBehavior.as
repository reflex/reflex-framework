package reflex.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	

	use namespace flash_proxy;
	
	/**
	 * A dynamic proxy for compositing multiple behaviors. The CompositeBehavior
	 * may be iterated through just as an Array might be.
	 */
	public dynamic class CompositeBehavior extends Proxy implements IBehavior, IEventDispatcher
	{
		
		private var _target:IEventDispatcher;
		
		private var behaviors:Array;
		private var dictionary:Dictionary;
		private var dispatcher:EventDispatcher;
		
		
		/**
		 * Constructor.
		 * 
		 * @param The target for this behavior map.
		 */
		public function CompositeBehavior(target:IEventDispatcher = null)
		{
			_target = target;
			behaviors = [];
			dictionary = new Dictionary(false);
		}
		
		
		[Bindable("targetChange")]
		/**
		 * The object which the behaviors in this map will act upon.
		 */
		public function get target():IEventDispatcher
		{
			return _target;
		}
		
		public function set target(value:IEventDispatcher):void
		{
			if (value == _target) return;
			_target = value;
			for each (var behavior:IBehavior in dictionary) {
				behavior.target = value;
			}
			dispatch("targetChange");
		}
		
		
		public function get length():uint {
			return behaviors.length;
		}
		public function set length(value:uint):void {
			// remove target from truncated items?
			behaviors.length = value;
		}
		
		//[ArrayElementType("reflex.core.IBehavior")]
		public function add(item:Object):uint
		{
			if(item is IBehavior) {
				(item as IBehavior).target = _target;
				behaviors.push(item as IBehavior);
			} else if(item is Array) {
				for each (var behavior:IBehavior in item) {
					behavior.target = _target;
					behaviors.push(behavior);
				}
			}
			return behaviors.length;
		}
		
		public function clear():Array {
			for each(var behavior:IBehavior in behaviors) {
				behavior.target = null;
				//delete dictionary[behavior];
			}
			behaviors = [];
			dictionary = new Dictionary(); // delete keys instead
			return null;
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
		 * to be determined
		 */
		override flash_proxy function callProperty(name:*, ...rest):*
		{
			return null;
		}
		
		
		private var props:Array;
		
		/**
		 * Proxy method allowing looping through the map.
		 */
		override flash_proxy function nextName(index:int):String
		{
			return (index - 1).toString();
		}
		
		/**
		 * Proxy method allowing looping through the map.
		 */
		override flash_proxy function nextValue(index:int):*
		{
			return behaviors[index-1];
		}
		
		/**
		 * Proxy method allowing looping through the map.
		 */
		override flash_proxy function nextNameIndex(index:int):int
		{
			if(index < behaviors.length) {
				return index + 1;
			} else {
				return 0;
			}
			//return (index + 1) % (props.length + 1); // returns 0 when it hits length
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