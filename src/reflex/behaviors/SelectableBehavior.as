package reflex.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;

	public class SelectableBehavior extends Behavior implements IBehavior
	{
		[Bindable]
		public var selected:Boolean;
		
		public function SelectableBehavior(target:InteractiveObject = null)
		{
			super(target);
			bindProperty("selected", "target.selected");
			bindEventListener("click", onClick, "target");
		}
		
		
		protected function onClick(event:MouseEvent):void
		{
			selected = !selected;
			event.updateAfterEvent();
		}
		
	}
}