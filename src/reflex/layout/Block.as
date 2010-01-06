package reflex.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import reflex.core.Invalidator;
	
	public class Block extends EventDispatcher
	{
		public static var targetsBlocks:Dictionary = new Dictionary(true); 
		
		protected var _target:DisplayObject;
		
		protected var _minWidth:Number = 0;
		protected var _minHeight:Number = 0;
		protected var _maxWidth:Number = Number.MAX_VALUE;
		protected var _maxHeight:Number = Number.MAX_VALUE;
		protected var _margin:Edges = new Edges();
		protected var _padding:Edges = new Edges();
		protected var _dock:String = Dock.NONE;
		protected var _tile:String = Tile.NONE;
		
		// holds explicitly set value from setting width/height
		protected var explicitWidth:Number;
		protected var explicitHeight:Number;
		
		// calculated from children, but can be set with setMeasuredSize();
		protected var measuredWidth:Number;
		protected var measuredHeight:Number;
		
		// derived from measured and explicit width, but can be set with setActualSize();
		protected var _actualWidth:Number = 0;
		protected var actualHeight:Number = 0;
		
		protected var calculatedMinWidth:Number = 0;
		protected var calculatedMinHeight:Number = 0;
		protected var calculatedMaxWidth:Number = Number.MAX_VALUE;
		protected var calculatedMaxHeight:Number = Number.MAX_VALUE;
		
		protected var constrainedVertically:Boolean;
		protected var constrainedHorizontally:Boolean;
		
		public function Block(target:DisplayObject = null)
		{
			this.target = target;
		}
		
		
		public function get target():DisplayObject
		{
			return _target;
		}
		
		public function set target(value:DisplayObject):void
		{
			if (_target == value) return;
			
			if (_target) {
				delete targetsBlocks[_target];
				_target.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			
			_target = value;
			
			if (_target) {
				if (_target in targetsBlocks) {
					targetsBlocks[_target].target = null;
				}
				
				targetsBlocks[_target] = this;
				_target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}
		
		
		public function get width():Number
		{
			if (!isNaN(_actualWidth)) return _actualWidth;
			if (!isNaN(explicitWidth)) return explicitWidth;
			if (!isNaN(measuredWidth)) return measuredWidth;
			return 0;
		}
		
		public function set width(value:Number):void
		{
			value = Math.min(calculatedMaxWidth, Math.max(calculatedMinWidth, value));
			
			if (value == explicitWidth) return;
			
			explicitWidth = value;
			
			if (!constrainedHorizontally && isNaN(_actualWidth)) {
				invalidateLayout();
			}
		}
		
		
		public function get height():Number
		{
			if (!isNaN(actualHeight)) return actualHeight;
			if (!isNaN(explicitHeight)) return explicitHeight;
			if (!isNaN(measuredHeight)) return measuredHeight;
			return 0;
		}
		
		public function set height(value:Number):void
		{
			value = Math.min(calculatedMaxHeight, Math.max(calculatedMinHeight, value));
			
			if (value == explicitHeight) return;
			
			explicitHeight = value;
			
			if (!constrainedVertically && isNaN(actualHeight)) {
				invalidateLayout();
			}
		}
		
		
		
		
		public function get minWidth():Number
		{
			return _minWidth;
		}
		
		public function set minWidth(value:Number):void
		{
			value = Math.max(0, value || 0);
			
			if (value == _minWidth) return;
			
			_minWidth = value;
			
			if (calculatedMinWidth < value) {
				calculatedMinWidth = value;
				invalidate();
				
				if (!isNaN(_actualWidth) && _actualWidth < calculatedMinWidth) {
					invalidateLayout();
				} else if (!isNaN(explicitWidth) && explicitWidth < calculatedMinWidth) {
					invalidateLayout();
				} else if (!isNaN(measuredWidth) && measuredWidth < calculatedMinWidth) {
					invalidateLayout();
				}
				
				_actualWidth = Math.max(_actualWidth, calculatedMinWidth);
				explicitWidth = Math.max(explicitWidth, calculatedMinWidth);
				measuredWidth = Math.max(measuredWidth, calculatedMinWidth);
				maxWidth = Math.max(_maxWidth, calculatedMinWidth);
			}
		}
		
		
		public function get minHeight():Number
		{
			return _minHeight;
		}
		
		public function set minHeight(value:Number):void
		{
			value = Math.max(0, value || 0);
			
			if (value == _minHeight) return;
			
			_minHeight = value;
			
			if (calculatedMinHeight < value) {
				calculatedMinHeight = value;
				invalidate();
				
				if (!isNaN(actualHeight) && actualHeight < value) {
					invalidateLayout();
				} else if (!isNaN(explicitHeight) && explicitHeight < value) {
					invalidateLayout();
				} else if (!isNaN(measuredHeight) && measuredHeight < value) {
					invalidateLayout();
				}
				
				actualHeight = Math.max(actualHeight, value);
				explicitHeight = Math.max(explicitHeight, value);
				measuredHeight = Math.max(measuredHeight, value);
				maxHeight = Math.max(_maxHeight, value);
			}
		}
		
		
		
		public function get maxWidth():Number
		{
			return _maxWidth;
		}
		
		public function set maxWidth(value:Number):void
		{
			value = Math.max(_minWidth, value);
			if (value == _maxWidth) return;
			
			_maxWidth = value;
			
			if (calculatedMaxWidth > value) {
				calculatedMaxWidth = value;
				invalidate();
			}
		}
		
		
		public function get maxHeight():Number
		{
			return _maxHeight;
		}
		
		public function set maxHeight(value:Number):void
		{
			value = Math.max(_minHeight, value);
			if (value == _maxHeight) return;
			
			_maxHeight = value;
			
			if (calculatedMaxHeight > value) {
				calculatedMaxHeight = value;
				invalidate();
			}
		}
		
		
		public function get padding():Edges
		{
			return _padding;
		}
		
		public function set padding(value:*):void
		{
			if (value is String && value != "") value = Edges.fromString(value);
			if ( !(value is Edges) ) {
				throw new ArgumentError("Padding must be a Edges object or a valid string representation of one.");
			}
			
			if (_padding.equals(value)) return;
			
			_padding = value as Edges;
		}
		
		
		public function get margin():Edges
		{
			return _margin;
		}
		
		public function set margin(value:*):void
		{
			if (value is String && value != "") value = Edges.fromString(value);
			if ( !(value is Edges) ) {
				throw new ArgumentError("Margin must be a Edges object or a valid string representation of one.");
			}
			
			if (_margin.equals(value)) return;
			
			_margin = value as Edges;
		}
		
		
		public function get dock():String
		{
			return _dock;
		}
		
		public function set dock(value:String):void
		{
			if (value != Dock.TOP || value != Dock.RIGHT || value != Dock.BOTTOM || value != Dock.BOTTOM || value != Dock.FILL) {
				value = Dock.NONE;
			}
			
			if (value == _dock) return;
			
			// dock cannot be none or fill when tile is set
			if (_tile != Tile.NONE && (value == Dock.NONE || value == Dock.FILL)) {
				throw new ArgumentError('Dock cannot be "none" or "fill" when tile is set');
			}
			
			_dock = value;
		}
		
		
		public function get tile():String
		{
			return _tile;
		}
		
		public function set tile(value:String):void
		{
			if (value != Tile.TOP || value != Tile.RIGHT || value != Tile.BOTTOM || value != Tile.BOTTOM) {
				value = Tile.NONE;
			}
			
			if (value == _tile) return;
			
			if (_dock == Dock.NONE || _dock == Dock.FILL) {
				if (value == Tile.LEFT || value == Tile.RIGHT) {
					_dock = Dock.TOP;
				} else {
					_dock = Dock.LEFT;
				}
			}
			
			_tile = value;
		}
		
		
		public function setMeasuredSize(width:Number, height:Number):void
		{
			width = Math.min(calculatedMaxWidth, Math.max(calculatedMinWidth, width));
			height = Math.min(calculatedMaxHeight, Math.max(calculatedMinHeight, height));
			
			if (measuredWidth == width && measuredHeight == height) return;
			
			
		}
		
		
		public function updateConstraints():void
		{
			if (_target) Invalidator.uninvalidate(_target, updateConstraints);
			
			
		}
		
		
		protected function calculateSize():void
		{
			
		}
		
		
		public function invalidate():void
		{
			if (_target) Invalidator.invalidate(_target, updateConstraints, Layout.CONSTRAINT_PRIORITY);
		}
		
		protected function invalidateLayout():void
		{
			if (!_target || !_target.parent || !(_target.parent in Layout.targetsLayouts)) return;
			Layout(Layout.targetsLayouts[_target.parent]).invalidate();
		}
		
		private function onAddedToStage(event:Event):void
		{
			invalidate();
			invalidateLayout();
		}
	}
}