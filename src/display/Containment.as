package display
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import flight.binding.Bind;
	import flight.events.PropertyEvent;
	import flight.position.IPosition;
	import flight.position.Position;

	public class Containment
	{
		[Bindable]
		public var hPosition:IPosition = new Position();		// TODO: implement lazy instantiation of Position
		
		[Bindable]
		public var vPosition:IPosition = new Position();
		
		private var _target:DisplayObject;
		
		public function Containment(target:DisplayObject = null)
		{
			Bind.addListener(onPositionChange, this, "hPosition.value");
			Bind.addListener(onPositionChange, this, "vPosition.value");
			Bind.addListener(onSizeChange, this, "hPosition.space");
			Bind.addListener(onSizeChange, this, "vPosition.space");
			
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
			
			if (_target != null) {
				hPosition.size = _target.width;
				vPosition.size = _target.height;
				_target.scrollRect = new Rectangle(hPosition.value, vPosition.value, hPosition.space, vPosition.space);
			}
			
			PropertyEvent.dispatchChange(this, "target", oldValue, _target);
		}
		
		private function onPositionChange(event:PropertyEvent):void
		{
			if (target == null) {
				return;
			}
			
			var rect:Rectangle = target.scrollRect;
			rect.x = hPosition.value;
			rect.y = vPosition.value;
			target.scrollRect = rect;
		}
		
		private function onSizeChange(event:PropertyEvent):void
		{
			if (target == null) {
				return;
			}
			
			var rect:Rectangle = target.scrollRect;
			rect.width = hPosition.space;
			rect.height = vPosition.space;
			target.scrollRect = rect;
		}
		
	}
}
