package reflex.behaviors
{
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import reflex.events.PropertyEvent;
	
	/**
	 * @description Adds selection toggling functionality to the target. When clicked, the target's selected property will be flipped.
	 * @alpha
	 */
	public class SelectableBehavior extends Behavior implements IBehavior
	{
		
		private var _selected:Boolean;
		
		[Bindable(event="selectedChange")]
		[Binding(target="target.selected")]
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			if (_selected == value) {
				return;
			}
			PropertyEvent.dispatchChange(this, "selected", _selected, _selected = value);
		}
		
		public function SelectableBehavior(target:IEventDispatcher= null)
		{
			super(target);
		}
		
		/**
		 * @private
		 */
		[EventListener(type="click", target="target")]
		public function onClick(event:MouseEvent):void
		{
			selected = !selected;
			event.updateAfterEvent();
		}
		
	}
}