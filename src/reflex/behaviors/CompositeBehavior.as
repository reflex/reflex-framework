package reflex.behaviors
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	
	import reflex.core.IBehavior;

	public dynamic class CompositeBehavior extends Proxy implements IBehavior, IEventDispatcher
	{
		protected var _owner:Object;
		protected var dispatcher:EventDispatcher;
		protected var behaviors:Object = {};
		private var props:Array;
		
		public function CompositeBehavior()
		{
			super();
		}
		
		public function get owner():Object
		{
			return _owner;
		}
		
		public function set owner(value:Object):void
		{
			if (value == object) return;
			_owner = value;
			for each (var behavior:IBehavior in behaviors) {
				behavior.owner = value;
			}
		}
		
		override flash_proxy function getProperty(name:*):*
		{
			return behaviors[name];
		}
		
		override flash_proxy function setProperty(name:*, value:*):void
		{
			behaviors[name] = value;
		}
		
		override flash_proxy function deleteProperty(name:*):Boolean
		{
			return delete behaviors[name];
		}
		
		override flash_proxy function hasProperty(name:*):Boolean
		{
			return (name in behaviors);
		}
		
		override flash_proxy function callProperty(name:*, ... rest):*
		{
			if (name in behaviors && "execute" in behaviors[name]) {
				return behaviors[name].execute.apply(null, rest);
			}
		}
		
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
		
		override flash_proxy function nextValue(index:int):*
		{
			return behaviors[props[index - 1]];
		}
		
		override flash_proxy function nextNameIndex(index:int):int
		{
			return (index + 1) % (adapter.length + 1); // returns 0 when it hits length
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