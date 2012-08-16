package reflex.invalidation
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.IList;
	
	import reflex.components.Component;
	import reflex.containers.Container;
	import reflex.containers.IContainer;

	public class InvalidationPhase
	{
		/**
		 * The priority of this phase relating to other invalidation phases.
		 */
		public var priority:int = 0;
		
		/**
		 * The event class instantiated for dispatch from invalidation targets.
		 */
		public var eventType:Class;
		
		public var ascending:Boolean;
		
		/**
		 * Quick reference with invalidated targets as key and value as level.
		 */
		public var invalid:Dictionary = new Dictionary(true);
		
		/**
		 */
		public var invalidContent:Dictionary = new Dictionary(true);
		
		private var indices:Dictionary = new Dictionary(true);
		
		/**
		 * Constructor requiring phase name also used as event type, and
		 * optionally the class used for event instantiation.
		 * 
		 * @param name			Phase name, also the event type.
		 * @param eventType		Event class used when dispatching from
		 * 						invalidation targets.
		 */
		public function InvalidationPhase(name:String, eventType:Class = null, ascending:Boolean = false)
		{
			_name = name;
			this.eventType = eventType || Event;
			this.ascending = ascending;
		}
		
		/**
		 * Phase name, also used as the event type.
		 */
		public function get name():String { return _name; }
		private var _name:String;
		
		
		/**
		 * Effectively invalidates target with this phase.
		 * 
		 * @param target		Target to be invalidated.
		 * @return				Returns true the first time target is
		 * 						invalidated.
		 */
		public function invalidate(target:IEventDispatcher):Boolean
		{
			
			if (!target || invalid[target]) {
				return false;
			}
			
			invalid[target] = true;
			
			var parent:IEventDispatcher = (target as Object).owner; //var parent:DisplayObjectContainer = target.parent;
			while (parent && !invalidContent[parent]) {
				invalidContent[parent] = true;
				parent = !(parent is Stage) ? (parent as Object).owner : null; // parent.parent;
			}
			
			return true;
		}
		
		/**
		 * Execution of the phase by dispatching an event from each target, in order
		 * ascending or descending by level. Event type and class correlate with
		 * phase name and eventType respectively.
		 * 
		 * @param target		Optional target may be specified for isolated
		 * 						validation. If null, full validation is run on
		 * 						all targets in proper level order.
		 */
		public function validateNow(target:IEventDispatcher):void
		{
			var current:IEventDispatcher; //DisplayObjectContainer;
			var next:IEventDispatcher;
			var i:int;
			
			// flattened recursive process to maintain a shallow stack
			if (ascending) {
				
				if (invalidContent[target]) {
					delete invalidContent[target];
					current = target;//DisplayObjectContainer(target);
					indices[current] = 0;
					
					while (current) {
						
						i = indices[current]++;
						var content:IList = null;
						if(current is Component) {
							next = i == 0 ? (current as Component).skin as IEventDispatcher : null;
							//indices[current] = 0;
						} else if(current is IContainer) {
							content = (current as IContainer).content;
							next = (content && i < content.length) ? (current as Container).getRendererForItem(content.getItemAt(i)) as IEventDispatcher : null;
						}
						//next = i < (current as Stage).numChildren ? (current as Stage).getChildAt(i) : null; // trouble here
						if (next) {
							if (invalidContent[next]) {
								delete invalidContent[next];
								
								current = next;
								indices[current] = 0;
							} else if (invalid[next]) {
								delete invalid[next];
								next.dispatchEvent(new eventType(_name));
							}
						} else {
							if (invalid[current]) {
								delete invalid[current];
								current.dispatchEvent(new eventType(_name));
							}
							delete indices[current];
							current = current != target ? (current as Object).owner : null;//current = current != target ? current.parent : null;
						}
					}
					
				} else if (invalid[target]) {
					delete invalid[target];
					target.dispatchEvent(new eventType(_name));
				}
				
			} else {
				
				if (invalid[target]) {
					delete invalid[target];
					target.dispatchEvent(new eventType(_name));
				}
				
				if (invalidContent[target]) {
					delete invalidContent[target];
					current = target; //DisplayObjectContainer(target);
					indices[current] = 0;
					
					while (current) {
						
						i = indices[current]++;
						content = null;
						if(current is Component) {
							next = i==0 ? (current as Component).skin as IEventDispatcher : null;
							//indices[current] = 0;
						} else if(current is IContainer) {
							content = (current as IContainer).content;
							next = (content && i < content.length) ? (current as Container).getRendererForItem(content.getItemAt(i)) as IEventDispatcher : null;
						}
						//next = i < (current as Stage).numChildren ? (current as Stage).getChildAt(i) : null; // trouble here
						if (next) {
							if (invalid[next]) {
								delete invalid[next];
								next.dispatchEvent(new eventType(_name));
							}
							
							if (invalidContent[next]) {
								delete invalidContent[next];
								
								current = next; // DisplayObjectContainer(next);
								indices[current] = 0;
							}
						} else {
							delete indices[current];
							current = current != target ? (current as Object).owner : null; // current = current != target ? current.parent : null;
						}
					}
				}
				
			}
			
			
		}
	}
}