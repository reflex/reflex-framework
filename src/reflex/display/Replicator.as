package reflex.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	import flight.binding.Bind;
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.events.PropertyEvent;
	import flight.list.ArrayList;
	import flight.list.IList;
	import flight.position.IPosition;
	import flight.position.Position;
	
	import reflex.components.Button;
	
	/**
	 * A replicator can create any inanimate matter, as long as the desired
	 * molecular structure is on file, but it cannot create antimatter,
	 * dilithium, latinum, or a living organism of any kind.
	 */
	public class Replicator extends EventDispatcher
	{
		[Bindable]
		public var position:IPosition = new Position();
		
		[Bindable]
		public var dataProvider:IList = new ArrayList();
		
		public var template:Class = Button;
		
		/*
		replicating subject
		1) single template defined on component
		2) template tied to data type
		3) template retrieved through data inspection
		
		data discovered by template (both scenarios provide property mapping)
		1) (pull) data property assigned and template coded to it
		2) (push) data automatically assigned to template properties (injection)
		*/
		
		private var _target:DisplayObjectContainer;
		
		public function Replicator(target:DisplayObjectContainer = null)
		{
			Bind.addListener(onPositionChange, this, "position.percent");
			this.target = target;
			
			dataProvider.addEventListener(ListEvent.LIST_CHANGE, onChildrenChange);
		}
		
		[Bindable(event="targetChange")]
		public function get target():DisplayObjectContainer
		{
			return _target;
		}
		public function set target(value:DisplayObjectContainer):void
		{
			if (_target == value) {
				return;
			}
			
			if (_target != null) {
			}
			
			var oldValue:Object = _target;
			_target = value;
			
			if (_target != null) {
			}
			
			PropertyEvent.dispatchChange(this, "target", oldValue, _target);
		}
		
		private function onPositionChange(event:PropertyEvent):void
		{
			
		}
		
		private function onChildrenChange(event:ListEvent):void
		{
			if (_target  == null) {
				return;
			}
			
			var data:Object;
			var child:DisplayObject;
			var loc:int = event.location1;
			switch (event.kind) {
				case ListEventKind.ADD :
					for each (data in event.items) {
						child = new template() as DisplayObject;
						// TODO: assign data to child
						_target.addChildAt(child, loc++);
					}
					break;
				case ListEventKind.REMOVE :
					for each (data in event.items) {
						_target.removeChildAt(loc);
					}
					break;
				case ListEventKind.REPLACE :
					child = _target.getChildAt(loc);
					// TODO: assign data to child
					break;
				case ListEventKind.RESET :
					while (_target.numChildren > dataProvider.length) {
						_target.removeChildAt(_target.numChildren-1);
					}
					for (var i:int = 0; i < dataProvider.length; i++) {
						child = i < _target.numChildren ? _target.getChildAt(i) : new template() as DisplayObject;
						// TODO: assign data to child
						_target.addChildAt(child, i);
					}
					break;
			}
		}
		
		private function onVirtualChange(event:ListEvent):void
		{
			if (_target  == null) {
				return;
			}
			
			var child:DisplayObject;
			var loc:int = event.location1;
			switch (event.kind) {
				case ListEventKind.ADD :
					
					break;
				case ListEventKind.REMOVE :
					
					break;
				case ListEventKind.REPLACE :
					
					break;
				case ListEventKind.RESET :
					
					break;
			}
		}
		
	}
}