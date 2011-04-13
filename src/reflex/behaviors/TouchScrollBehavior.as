package reflex.behaviors
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.geom.Vector3D;
	
	import reflex.behaviors.Behavior;
	import reflex.data.IPosition;
	import reflex.measurement.resolveHeight;
	import reflex.measurement.resolveWidth;
	
	//[HostComponent("flash.display.DisplayObject")]
	public class TouchScrollBehavior extends Behavior
	{
		
		[Binding(target="target")]
		public var hostComponent:DisplayObject;
		
		private var point:Point;
		private var speed:Point;
		private var drag:Number = 0.95;
		
		[Bindable]
		[Binding(target="target.verticalPosition")]
		public var verticalPosition:IPosition;
		
		[Bindable]
		[Binding(target="target.horizontalPosition")]
		public var horizontalPosition:IPosition;
		
		[Bindable]
		[Binding(target="target.skin.container")]
		public var container:Object;
		
		public var horizontalControl:Boolean = true;
		public var verticalControl:Boolean = true;
		
		public function TouchScrollBehavior(target:IEventDispatcher=null, horizontalControl:Boolean = true, verticalControl:Boolean = true)
		{
			super(target);
			this.horizontalControl = horizontalControl;
			this.verticalControl = verticalControl;
			point = new Point();
			speed = new Point();
		}
		
		[EventListener(event="mouseDown", target="target")]
		public function onMouseDown(event:MouseEvent):void {
			point.x = hostComponent.mouseX;
			point.y = hostComponent.mouseY;
			hostComponent.removeEventListener(Event.ENTER_FRAME, animation_enterFrameHandler, false);
			hostComponent.addEventListener(Event.ENTER_FRAME, scrolling_enterFrameHandler, false, 0, true);
			hostComponent.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			drag = 0.95;
		}
		
		private function onMouseUp(event:MouseEvent):void {
			speed.x = point.x - hostComponent.mouseX;
			speed.y = point.y - hostComponent.mouseY;
			point.x = hostComponent.mouseX;
			point.y = hostComponent.mouseY;
			//(target as DisplayObject).removeEventListener(MouseEvent.MOUSE_MOVE, scrolling_enterFrameHandler, false);
			hostComponent.removeEventListener(Event.ENTER_FRAME, scrolling_enterFrameHandler, false);
			hostComponent.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
			hostComponent.addEventListener(Event.ENTER_FRAME, animation_enterFrameHandler, false, 0, true);
		}
		
		private function scrolling_enterFrameHandler(event:Event):void {
			speed.x = point.x - hostComponent.mouseX;
			speed.y = point.y - hostComponent.mouseY;
			point.x = hostComponent.mouseX;
			point.y = hostComponent.mouseY;
			updatePositions();
		}
		
		private function animation_enterFrameHandler(event:Event):void {
			
			updatePositions();
			speed.x = speed.x * drag;
			speed.y = speed.y * drag;
			drag -= 0.005;
			if(drag < 0.1) {
				hostComponent.removeEventListener(Event.ENTER_FRAME, animation_enterFrameHandler, false);
			}
			
		}
		
		private function updatePositions():void {
			if(horizontalPosition && horizontalControl) {
				var percentX:Number = speed.x/(container.measured.width-hostComponent.height);
				var potentialX:Number = percentX*(horizontalPosition.maximum - horizontalPosition.minimum);
				var px:Number = horizontalPosition.value + potentialX;
				horizontalPosition.value = Math.max(horizontalPosition.minimum, Math.min(horizontalPosition.maximum, px));
			}
			if(verticalPosition && verticalControl) {
				var percentY:Number = speed.y/(container.measured.height-hostComponent.height);
				var potentialY:Number = percentY*(verticalPosition.maximum - verticalPosition.minimum);
				var py:Number = verticalPosition.value + potentialY;
				verticalPosition.value = Math.max(verticalPosition.minimum, Math.min(verticalPosition.maximum, py));
			}
		}
		
	}
}