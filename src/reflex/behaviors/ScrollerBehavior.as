package reflex.behaviors
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import reflex.data.IPosition;
	
	public class ScrollerBehavior extends Behavior
	{
		
		private var _horizontalPosition:IPosition;
		private var _verticalPosition:IPosition;
		private var _container:DisplayObject;
		
		[Bindable(event="horizontalPositionChange")]
		[Binding(target="target.horizontalPosition")]
		public function get horizontalPosition():IPosition { return _horizontalPosition; }
		public function set horizontalPosition(value:IPosition):void {
			notify("horizontalPosition", _horizontalPosition, _horizontalPosition = value);
		}
		
		[Bindable(event="verticalPositionChange")]
		[Binding(target="target.verticalPosition")]
		public function get verticalPosition():IPosition { return _verticalPosition; }
		public function set verticalPosition(value:IPosition):void {
			notify("verticalPosition", _verticalPosition, _verticalPosition = value);
		}
		
		[Bindable(event="containerChange")]
		[Binding(target="target.skin.container")]
		public function get container():DisplayObject { return _container; }
		public function set container(value:DisplayObject):void {
			notify("container", _container, _container = value);
		}
		
		public function ScrollerBehavior(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		[EventListener(event="widthChange", target="container")]
		[EventListener(event="valueChange", target="horizontalPosition")]
		[EventListener(event="minimumChange", target="horizontalPosition")]
		[EventListener(event="maximumChange", target="horizontalPosition")]
		public function onHorizontalChange(event:Event):void {
			var percent:Number = (horizontalPosition.value-horizontalPosition.minimum)/(horizontalPosition.maximum-horizontalPosition.minimum);
			var potential:Number = (_container  as Object).measured.width-(target as Object).width;
			_container.x = Math.round(potential*percent*-1);
		}
		
		[EventListener(event="heightChange", target="container")]
		[EventListener(event="valueChange", target="verticalPosition")]
		[EventListener(event="minimumChange", target="verticalPosition")]
		[EventListener(event="maximumChange", target="verticalPosition")]
		public function onVerticalChange(event:Event):void {
			var percent:Number = (verticalPosition.value-verticalPosition.minimum)/(verticalPosition.maximum-verticalPosition.minimum);
			var potential:Number = (_container  as Object).measured.height-(target as Object).height;
			_container.y = Math.round(potential*percent*-1);
		}
		
	}
}