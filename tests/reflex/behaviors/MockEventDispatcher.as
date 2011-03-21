package reflex.behaviors {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class MockEventDispatcher implements IEventDispatcher {

		public function MockEventDispatcher() {
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return false;
		}
		
		public function hasEventListener(type:String):Boolean {
			return false;
		}
		
		public function willTrigger(type:String):Boolean {
			return false;
		}
	}
}