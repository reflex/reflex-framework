package reflex.metadata
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.getQualifiedClassName;
	
	import flight.binding.Bind;
	
	import reflex.events.InvalidationEvent;
	
	// for lack of a better name
	
	/**
	 * Helps implement CommitProperties metadata functionality.
	 * 
	 * @experimental
	 */
	public class CommitUtility extends EventDispatcher
	{
		
		static public var instance:CommitUtility = new CommitUtility();
		
		private var dictionary:Dictionary = new Dictionary(true);
		private var bindings:Array = [];
		
		public function register(instance:IEventDispatcher, method:String, properties:Array, resolver:Function):void {
			var token:String = flash.utils.getQualifiedClassName(instance) + "_" + method + "Commit";
			InvalidationEvent.registerPhase(token, 0, true);
			for each(var sourcePath:String in properties) {
				var sourceToken:String = flash.utils.getQualifiedClassName(instance) + "_" + sourcePath;
				var array:Array = dictionary[sourceToken];
				if(array == null) {
					dictionary[sourceToken] = array = [];
				}
				array.push(token);
				
				bindings.push( Bind.addListener(instance, invalidationHandler, instance, sourcePath) );
				//bindings.push( Bind.bindEventListener(token, invalidationHandler, instance, sourcePath, false, 0, false) );
			}
			
			var f:Function = resolver != null ? resolver(method) : instance[method];
			//instance.addEventListener(token, commitHandler, false, 0, true);
			instance.addEventListener(token, f, false, 0, true);
		}
		
		private function invalidationHandler(s1:Object, s2:Object = null, s3:Object = null, s4:Object = null):void {
			//var binding:Binding = s1 as Binding;
			if(s2 is DisplayObject) {
				var sourceToken:String =  flash.utils.getQualifiedClassName(s2) + "_" + s1.sourcePath;
				var tokens:Array = dictionary[sourceToken];
				for each(var token:String in tokens) {
					InvalidationEvent.invalidate(s2 as DisplayObject, token);
				}
			}
		}
		
		private function commitHandler(event:InvalidationEvent):void {
			//var instance:IEventDispatcher;
			//var f:Function = instance[method];
		}
		
	}
}