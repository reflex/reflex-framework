package reflex.behavior
{
	import flash.events.MouseEvent;
	
	import reflex.controls.ISelectable;
	import reflex.core.IBehavior;

	public class SelectableBehavior extends Behavior implements IBehavior
	{
		[Alias] [Bindable] public var select:ISelectable;
		
		[EventListener(type="click")]
		public function onClick(event:MouseEvent):void {
			select.selected = !select.selected;
			event.updateAfterEvent();
		}
		
	}
}