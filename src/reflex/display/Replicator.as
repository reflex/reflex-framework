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
	import reflex.layout.LayoutWrapper;
	
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
		
		public var children:IList = new ArrayList();
		
		// TODO: replicating subject
		// 1) single template defined on component
		// 2) template tied to data type
		// 3) template retrieved through data inspection
		
		[Bindable]
		public var template:Class = Button;
		
		[Bindable]
		public var coverageSize:Number = 0;	// size of coverage area (viewport)
		
		[Bindable]
		public var itemSize:Number = 20;		// assumed size of all items		// TOOD: implement begin/end padding and in-between pad
		
		private var cap:int = 0;
		private var shift:int = 0;
		private var _target:DisplayObjectContainer;
		
		public function Replicator(target:DisplayObjectContainer = null)
		{
//			Bind.addListener(this, onPositionChange, this, "position.percent");
			this.target = target;
			
			Bind.bindEventListener(ListEvent.LIST_CHANGE, onChildrenChange, this, "dataProvider");
			Bind.addListener(this, onDataProviderChange, this, "dataProvider");
			
			position.stepSize = 10;
			position.skipSize = 100;
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
		
		private function onPositionChange(percent:Number):void
		{
			var layout:LayoutWrapper = LayoutWrapper.getLayout(_target);
			if (layout == null) {
				return;
			}
			
			layout.shift = position.value % (itemSize*4);
			layout.invalidate(true);
			var oldShift:int = shift;
			shift = Math.floor(position.value / itemSize / 4)*4;
			
			if (shift == oldShift) {
				return;
			}
			
			// TODO: get rid of the hard-coded reference to button
			// TODO: reduce loops though something called logic - I'll do it later
			var i:int, button:Button;
			var reshuffle:int = shift - oldShift;
			if (Math.abs(reshuffle) < _target.numChildren) {
				if (reshuffle < 0) {
					for (i = 0; i > reshuffle; i--) {
						button = _target.getChildAt(_target.numChildren-1) as Button;
						_target.addChildAt(button, 0);
						button.label = String( dataProvider.getItemAt(shift-1 - reshuffle + i) );
					}
				} else {
					for (i = 0; i < reshuffle; i++) {
						button = _target.getChildAt(0) as Button;
						_target.addChildAt(button, _target.numChildren);
						button.label = String( dataProvider.getItemAt(shift + _target.numChildren - reshuffle + i) );
					}
				}
				
			} else {
				for (i = 0; i < _target.numChildren; i++) {
					button = _target.getChildAt(i) as Button;
					button.label = String( dataProvider.getItemAt(shift + i) );
				}
			}
		}
		
		private function onDataProviderChange(dp:IList):void
		{
			var data:Object;
			var child:DisplayObject;
			while (_target.numChildren > dataProvider.length) {
				_target.removeChildAt(_target.numChildren-1);
			}
			for (var i:int = 0; i < dataProvider.length; i++) {
				if (children.length < cap) {
					child = i < _target.numChildren ? _target.getChildAt(i) : new template() as DisplayObject;
					// TODO: assign data to child
					child["label"] = String( dataProvider.getItemAt(shift) );
					children.addItemAt(child, i);
					_target.addChildAt(child, i);
				}
			}
		}
		
		private function onVirtualChange(event:ListEvent):void
		{
			if (_target  == null) {
				return;
			}
			
			// measure
			cap = Math.ceil(coverageSize / itemSize) + 10;
			position.size = itemSize * dataProvider.length;
			position.space = coverageSize;
			
			var data:Object;
			var child:DisplayObject;
			var loc:int = event.location1;
			switch (event.kind) {
				case ListEventKind.ADD :
					for each (data in event.items) {
						if (children.length < cap) {
							child = new template() as DisplayObject;
							// TODO: assign data to child
							child["label"] = String( dataProvider.getItemAt(loc + shift) );
							children.addItemAt(child, loc);
							_target.addChildAt(child, loc++);
						}
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
						if (children.length < cap) {
							child = i < _target.numChildren ? _target.getChildAt(i) : new template() as DisplayObject;
							// TODO: assign data to child
							child["label"] = String( dataProvider.getItemAt(shift) );
							children.addItemAt(child, i);
							_target.addChildAt(child, i);
						}
					}
					break;
			}
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
						child["data"] = data;
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
						child["data"] = data;
						_target.addChildAt(child, i);
					}
					break;
			}
		}
		
	}
}