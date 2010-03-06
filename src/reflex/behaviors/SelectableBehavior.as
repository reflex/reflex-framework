package reflex.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	import flight.observers.Observe;

	public class SelectableBehavior extends Behavior implements IBehavior
	{
		[Bindable]
		[Binding(target="target.selected")]
		public var selected:Boolean;
		
		[Bindable]
		[Binding(target="target.state")]
		public var state:String;
		
		public function SelectableBehavior(target:InteractiveObject = null)
		{
			super(target);
		}
		
		
		[PropertyListener(target="target")]
		public function targetChange(oldTarget:InteractiveObject, newTarget:InteractiveObject):void
		{
			if (oldTarget) Observe.removeHook(oldTarget, "state", keepState);
			if (newTarget) Observe.addHook(newTarget, "state", this, keepState);
		}
		
		
		public function keepState(currentState:String, newState:String):String
		{
			// only force to down for UP and OVER. Disabled should still be allowed.
			if (selected && (newState == ButtonBehavior.UP || newState == ButtonBehavior.OVER)) {
				return ButtonBehavior.DOWN;
			}
			
			return newState;
		}
		
		
		[EventListener(type="click", target="target")]
		public function onClick(event:MouseEvent):void
		{
			selected = !selected;
			state = selected ? ButtonBehavior.DOWN : ButtonBehavior.OVER;
			event.updateAfterEvent();
		}
		
	}
}