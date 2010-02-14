package reflex.display
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import flight.binding.Bind;
	import flight.events.PropertyEvent;
	import flight.position.IPosition;
	import flight.position.Position;

	public class ScrollRect extends EventDispatcher
	{
		[Bindable]
		public var hPosition:IPosition = new Position();		// TODO: implement lazy instantiation of Position
		
		[Bindable]
		public var vPosition:IPosition = new Position();
		
		[Bindable]
		public var x:Number;
		
		[Bindable]
		public var y:Number;
		
		[Bindable]
		public var width:Number;
		
		[Bindable]
		public var height:Number;
		
		private var _target:DisplayObject;
		
		public function ScrollRect(target:DisplayObject = null)
		{
			Bind.addBinding(this, "x", this, "hPosition.value", true);
			Bind.addBinding(this, "y", this, "vPosition.value", true);
			Bind.addBinding(this, "width", this, "hPosition.space", true);
			Bind.addBinding(this, "height", this, "vPosition.space", true);
			
			Bind.addListener(onPositionChange, this, "hPosition.value");
			Bind.addListener(onPositionChange, this, "vPosition.value");
			Bind.addListener(onSizeChange, this, "hPosition.space");
			Bind.addListener(onSizeChange, this, "vPosition.space");
			
			Bind.addBinding(this, "hPosition.size", this, "target.width");
			Bind.addBinding(this, "vPosition.size", this, "target.height");
			
			hPosition.stepSize = vPosition.stepSize = 10;
			hPosition.skipSize = vPosition.skipSize = 100;
			this.target = target;
		}
		
		[Bindable(event="targetChange")]
		public function get target():DisplayObject
		{
			return _target;
		}
		public function set target(value:DisplayObject):void
		{
			if (_target == value) {
				return;
			}
			
			if (_target != null) {
				_target.scrollRect = null;
			}
			
			var oldValue:Object = _target;
			_target = value;
			
			PropertyEvent.dispatchChange(this, "target", oldValue, _target);
		}
		
		private function onPositionChange(event:PropertyEvent):void
		{
			if (target == null) {
				return;
			}
			
			if (hPosition.filled && vPosition.filled) {
				target.scrollRect = null;
			} else {
				var rect:Rectangle = target.scrollRect || new Rectangle(hPosition.value, vPosition.value, hPosition.space, vPosition.space);
				rect.x = hPosition.value;
				rect.y = vPosition.value;
				target.scrollRect = rect;
			}
		}
		
		private function onSizeChange(event:PropertyEvent):void
		{
			if (target == null) {
				return;
			}
			
			if (hPosition.filled && vPosition.filled) {
				target.scrollRect = null;
			} else {
				var rect:Rectangle = target.scrollRect || new Rectangle(hPosition.value, vPosition.value, hPosition.space, vPosition.space);
				rect.width = hPosition.space;
				rect.height = vPosition.space;
				target.scrollRect = rect;
			}
		}
		
	}
}
