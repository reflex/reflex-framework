package reflex.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	/**
	 * @description Adds selection toggling functionality to the target. When clicked, the target's selected property will be flipped.
	 * @alpha
	 */
	public class SelectableBehavior extends Behavior implements IBehavior
	{
		[Bindable]
		[Binding(target="target.selected")]
		public var selected:Boolean;
		
		public function SelectableBehavior(target:InteractiveObject = null)
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