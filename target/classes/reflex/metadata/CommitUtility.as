package reflex.metadata
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import reflex.behaviors.IBehavior;
	import reflex.binding.Bind;
	import reflex.graphics.IDrawable;
	import reflex.invalidation.Invalidation;
	import reflex.skins.ISkin;
	
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
			Invalidation.registerPhase(token, 0, true);
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
			if(instance is IDrawable || instance is IBehavior || instance is ISkin) { // we really need a common interface for ITarget or something
				if((instance as Object).target) {
					(instance as Object).target.addEventListener(token, f, false, 0, true);
				}
			} else {
				instance.addEventListener(token, f, false, 0, true);
			}
		}
		
		// this is still a little hacky, but works for now
		// + it's in a good spot to clean up later
		private function invalidationHandler(s1:Object, s2:Object = null, s3:Object = null, s4:Object = null):void {
			//var binding:Binding = s1 as Binding;
			if(s2 is IEventDispatcher) {
				var sourceToken:String =  flash.utils.getQualifiedClassName(s2) + "_" + s1.sourcePath;
				var tokens:Array = dictionary[sourceToken];
				for each(var token:String in tokens) {
					if(s2 is IDrawable) { // we really need a common interface for ITarget or something
						Invalidation.invalidate((s2 as IDrawable).target as DisplayObject, token);
					} else if(s2 is IBehavior) {
						Invalidation.invalidate((s2 as IBehavior).target as DisplayObject, token);
					} else if(s2 is ISkin) {
						Invalidation.invalidate((s2 as ISkin).target as DisplayObject, token);
					} else  {
						Invalidation.invalidate(s2 as DisplayObject, token);
					}
				}
			}
		}
		
	}
}