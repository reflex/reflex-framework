package reflex.behaviors
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	
	import reflex.data.IPosition;
	
	public class TextAreaBehavior extends Behavior
	{
		
		private var _horizontalPosition:IPosition;
		private var _verticalPosition:IPosition;
		private var _textField:TextField;
		
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
		
		[Bindable(event="textFieldChange")]
		[Binding(target="target.skin.textField")]
		public function get textField():TextField { return _textField; }
		public function set textField(value:TextField):void {
			notify("textField", _textField, _textField = value);
		}
		
		public function TextAreaBehavior(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		[EventListener(event="valueChange", target="horizontalPosition")]
		[EventListener(event="minimumChange", target="horizontalPosition")]
		[EventListener(event="maximumChange", target="horizontalPosition")]
		public function onHorizontalChange(event:Event):void {
			var percent:Number = (horizontalPosition.value-horizontalPosition.minimum)/(horizontalPosition.maximum-horizontalPosition.minimum);
			//_container.x = (_container.width-(target as Object).width)*percent*-1;
			_textField.scrollH = (_textField.maxScrollV)*percent;
		}
		
		[EventListener(event="valueChange", target="verticalPosition")]
		[EventListener(event="minimumChange", target="verticalPosition")]
		[EventListener(event="maximumChange", target="verticalPosition")]
		public function onVerticalChange(event:Event):void {
			var percent:Number = (verticalPosition.value-verticalPosition.minimum)/(verticalPosition.maximum-verticalPosition.minimum);
			//_container.y = (_container.height-(target as Object).height)*percent*-1;
			_textField.scrollV = (_textField.maxScrollV)*percent;
		}
		
		[EventListener(event="scroll", target="textField")]
		[EventListener(event="change", target="textField")]
		[EventListener(event="widthChange", target="target")]
		[EventListener(event="heightChange", target="target")]
		public function onScrollChange(event:Event):void {
			if(_textField && _textField.maxScrollV > 1) {
				var percent:Number = _textField.scrollV/_textField.maxScrollV;
				var range:Number = _verticalPosition.maximum - _verticalPosition.minimum;
				_verticalPosition.value = _verticalPosition.minimum + range*percent;
			}
		}
		
	}
}