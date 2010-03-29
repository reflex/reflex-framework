package reflex.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;

	public class SelectableBehavior extends Behavior implements IBehavior
	{
		[Bindable]
		[Binding(target="target.selected")]
		public var selected:Boolean;
		
		public function SelectableBehavior(target:InteractiveObject = null)
		{
			super(target);
		}
		
		
		[EventListener(type="click", target="target")]
		public function onClick(event:MouseEvent):void
		{
			selected = !selected;
			event.updateAfterEvent();
		}
		
	}
}