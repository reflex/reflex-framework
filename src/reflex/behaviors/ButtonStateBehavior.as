package reflex.behaviors
{
	import flash.events.MouseEvent;
	
	import reflex.controls.IStateful;
	import reflex.core.IBehavior;
	
	public class ButtonStateBehavior extends Behavior implements IBehavior
	{
		
		[Alias] [Bindable] public var button:IStateful; // new comment
		
		reflex function button_mouseUpHandler(event:MouseEvent):void {
			button.state = "up";
		}
		
		// update
		
		reflex function button_mouseOutHandler(event:MouseEvent):void {
			button.state = "up";
		}
		
		reflex function button_mouseOverHandler(event:MouseEvent):void {
			button.state = "over";
		}
		
		reflex function button_mouseDownHandler(event:MouseEvent):void {
			button.state = "down";
		}
		
	}
}