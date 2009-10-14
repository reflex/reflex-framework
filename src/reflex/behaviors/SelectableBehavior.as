package reflex.behaviors
{
	import flash.events.MouseEvent;
	
	import reflex.controls.ISelectable;
	import reflex.core.IBehavior;

	public class SelectableBehavior extends Behavior implements IBehavior
	{
		
		[Bindable] public var selectable:Boolean; // keep in component?
		
		[Alias] [Bindable] public var select:ISelectable;
		
		reflex function select_clickHandler(event:MouseEvent):void {
			if(selectable) {
				select.selected = !select.selected;
			}
		}
		
	}
}