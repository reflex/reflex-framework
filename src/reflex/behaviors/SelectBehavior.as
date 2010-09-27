package reflex.behaviors
{
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import reflex.binding.DataChange;
	
	/**
	 * @description Adds selection toggling functionality to the target. When clicked, the target's selected property will be flipped.
	 * @alpha
	 */
	public class SelectBehavior extends Behavior implements IBehavior
	{
		
		private var _selected:Boolean;
		
		[Bindable(event="selectedChange")]
		[Binding(target="target.selected")]
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void {
			DataChange.change(this, "selected", _selected, _selected = value);
		}
		
		public function SelectBehavior(target:IEventDispatcher= null)
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
		}
		
	}
}