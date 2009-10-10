package reflex.behaviors
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	import reflex.metadata.Alias;
	import reflex.metadata.ClassDirectives;
	import reflex.metadata.EventHandler;
	import reflex.utils.MetaUtil;
	
	/**
	 * A base behavior class. Provides functionality for setting up listeners
	 * automatically with metadata.
	 */
	public class Behavior extends EventDispatcher
	{
		
		protected namespace reflex = "http://reflex.io";
		
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
			detach(_target);
			removeAliases();
			_target = value;
			applyAliases(_target);
			attach(_target);
			dispatch("targetChange");
		}
		
		
		////// Other base behavior methods which handle metadata etc. //////////
		
		private function attach(instance:Object):void {
			if(instance is IEventDispatcher) {
				var directives:ClassDirectives = MetaUtil.resolveDirectives(this);
				for each(var directive:EventHandler in directives.eventHandlers) {
					var f:Function = this.reflex::[directive.handler] as Function;
					var d:IEventDispatcher = this[directive.dispatcher] as IEventDispatcher;
					//dispatcher.addEventListener(directive.event, f, false, 0, true);
					if(d) {d.addEventListener(directive.event, f, false, 0, true); }
				}
			}
		}
		
		private function detach(instance:Object):void {
			if(instance is IEventDispatcher) {
				var directives:ClassDirectives = MetaUtil.resolveDirectives(this);
				for each(var directive:EventHandler in directives.eventHandlers) {
					var f:Function = this.reflex::[directive.handler] as Function;
					(instance as IEventDispatcher).removeEventListener(directive.event, f, false);
				}
			}
		}
		
		private function applyAliases(instance:Object):void {
			var directives:ClassDirectives = MetaUtil.resolveDirectives(this);
			for each(var alias:Alias in directives.aliases) {
				var type:Class = ApplicationDomain.currentDomain.getDefinition(alias.type) as Class;
				if(instance is type) {
					this[alias.property] = instance;
				}
			}
		}
		
		private function removeAliases():void {
			var directives:ClassDirectives = MetaUtil.resolveDirectives(this);
			for each(var alias:Alias in directives.aliases) {
				//var type:Class = ApplicationDomain.currentDomain.getDefinition(alias.type) as Class;
				//if(_target is type) {
					this[alias.property] = null;
				//}
			}
		}
		
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