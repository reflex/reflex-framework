package reflex.behaviors
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import reflex.binding.DataChange;
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
			DataChange.change(this, "horizontalPosition", _horizontalPosition, _horizontalPosition = value);
		}
		
		[Bindable(event="verticalPositionChange")]
		[Binding(target="target.verticalPosition")]
		public function get verticalPosition():IPosition { return _verticalPosition; }
		public function set verticalPosition(value:IPosition):void {
			DataChange.change(this, "verticalPosition", _verticalPosition, _verticalPosition = value);
		}
		
		[Bindable(event="containerChange")]
		[Binding(target="target.skin.container")]
		public function get container():DisplayObject { return _container; }
		public function set container(value:DisplayObject):void {
			DataChange.change(this, "container", _container, _container = value);
		}
		
		public function ScrollerBehavior(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		[EventListener(type="valueChange", target="horizontalPosition")]
		[EventListener(type="minimumChange", target="horizontalPosition")]
		[EventListener(type="maximumChange", target="horizontalPosition")]
		public function onHorizontalChange(event:Event):void {
			var percent:Number = (horizontalPosition.value-horizontalPosition.minimum)/(horizontalPosition.maximum-horizontalPosition.minimum);
			//_container.x = (_container.width-(target as Object).width)*percent*-1;
			_container.x = Math.round(((_container  as Object).measured.width-(target as Object).width)*percent*-1);
		}
		
		[EventListener(type="valueChange", target="verticalPosition")]
		[EventListener(type="minimumChange", target="verticalPosition")]
		[EventListener(type="maximumChange", target="verticalPosition")]
		public function onVerticalChange(event:Event):void {
			var percent:Number = (verticalPosition.value-verticalPosition.minimum)/(verticalPosition.maximum-verticalPosition.minimum);
			//_container.y = (_container.height-(target as Object).height)*percent*-1;
			_container.y = Math.round(((_container as Object).measured.height-(target as Object).height)*percent*-1);
		}
		
	}
}